Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab1LLLGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:06:55 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36041 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1LLLGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:06:51 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Mon, 12 Dec 2011 11:06:44 +0000
From: Tony Finch <dot@dotat.at>
X-X-Sender: fanf2@hermes-2.csi.cam.ac.uk
To: Michal Marek <mmarek@suse.cz>
cc: Mike Frysinger <vapier@gentoo.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unifdef: drop unused errno.h include
In-Reply-To: <20111210135456.GB22866@sepie.suse.cz>
Message-ID: <alpine.LSU.2.00.1112121040090.5322@hermes-2.csi.cam.ac.uk>
References: <1323210410-27111-1-git-send-email-vapier@gentoo.org> <20111210135456.GB22866@sepie.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 05:26:50PM -0500, Mike Frysinger wrote:
>
> This is the only header on my system that ends up requiring kernel
> headers, so if the kernel headers aren't available, we end up being
> unable to install kernel headers :).

I have some sympathy for this problem but I tend to think that it's
unreasonable to expect unifdef to work with an incomplete compiler
installation.

> Since this file doesn't actually use anything from errno.h, drop
> the include so it at least makes us a bit more robust on glibc.

The Linux kernel currently has unifdef-2.5. Version 2.6 has better error
handling so it uses the declaration of errno but not any of the E*
values. I could perhaps rejig it to avoid this if it really is important
to be able to bootsrap a system with incomplete headers.

Tony.
-- 
f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/
Lundy, Fastnet, Irish Sea: West, backing south for a time, 5 or 6, increasing
7 to severe gale 9. Moderate or rough, occasionally very rough or high. Rain
or squally wintry showers. Good, occasionally poor.

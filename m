Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2HTJf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:35:56 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:46805 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2HTJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:35:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Mon, 20 Aug 2012 10:35:50 +0100
From: Tony Finch <dot@dotat.at>
X-X-Sender: fanf2@hermes-1.csi.cam.ac.uk
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Tony Finch <dot@dotat.at>
Subject: Re: [PATCH] unifdef: set a secure umask before calling mkstemp()
In-Reply-To: <CAE2SPAacGx1Q3SOjwEGK9vuqBDq3S=A996JQkbDXC+7MkfiDXA@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1208201034460.9785@hermes-1.csi.cam.ac.uk>
References: <alpine.LNX.2.00.1208172136490.15699@swampdragon.chaosbits.net> <alpine.LSU.2.00.1208180025311.29492@hermes-1.csi.cam.ac.uk> <CAE2SPAacGx1Q3SOjwEGK9vuqBDq3S=A996JQkbDXC+7MkfiDXA@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien ROUCARIES <roucaries.bastien@gmail.com> wrote:
>
> have you tried gnulib for improving portability ?

My strategy is to try to avoid using anything outside the standard C89 library.

Tony.
-- 
f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/
Forties, Cromarty: East, veering southeast, 4 or 5, occasionally 6 at first.
Rough, becoming slight or moderate. Showers, rain at first. Moderate or good,
occasionally poor at first.

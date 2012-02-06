Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab2BFMmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:42:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab2BFMmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:42:39 -0500
Date: Mon, 6 Feb 2012 13:42:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: chris@cnpbagwell.com, pinglinux@gmail.com,
        linuxwacom-devel@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] HID: wacom: Fix invalid power_supply_powers calls
In-Reply-To: <d2139519eb66f9b7bfd8f56d3b4e2d96.squirrel@webmail.firszt.eu>
Message-ID: <alpine.LNX.2.00.1202061342090.24127@pobox.suse.cz>
References: <1328481324-7241-1-git-send-email-przemo@firszt.eu>    <alpine.LNX.2.00.1202061326150.24127@pobox.suse.cz> <d2139519eb66f9b7bfd8f56d3b4e2d96.squirrel@webmail.firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012, przemo@firszt.eu wrote:

> > Hmm, seems valid. How did you notice? Have you seen crashes because of
> > wild pointers?
> 
> Hi Jiri,
> Yes, the driver was unusable - 100% crashes during connection.

Okay, I thought that'd be the case.

> Chris came up with the solution, I did coding & testing.
> 
> The crash details are here:  http://pastebin.com/ZVNZWaPs

Thank you. Will be pushing to Linus soon.

-- 
Jiri Kosina
SUSE Labs

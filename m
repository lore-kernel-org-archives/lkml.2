Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1AHP2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 10:28:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:56370 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab1AHP2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:28:03 -0500
Date: Sat, 8 Jan 2011 16:28:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Switch turbox/mosart touchscreen to hid-mosart
In-Reply-To: <1294485342-2492-2-git-send-email-benjamin.tissoires@enac.fr>
Message-ID: <alpine.LNX.2.00.1101081627250.26685@pobox.suse.cz>
References: <1294485342-2492-1-git-send-email-benjamin.tissoires@enac.fr> <1294485342-2492-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Jan 2011, Benjamin Tissoires wrote:

> This device used the MULTI_INPUT quirk whereas it could be used
> with hid-mosart instead to support the multitouch part.
> 
> Reference: https://bugs.launchpad.net/ubuntu/+bug/620609/
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Applied to 'multitouch' part, and will be pushing it to Linus together 
with the hid-multitouch bits in the second merge round. Thanks,

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

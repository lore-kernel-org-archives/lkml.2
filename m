Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1AXPRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:17:10 -0500
Received: from cantor.suse.de ([195.135.220.2]:34686 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab1AXPRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:17:08 -0500
Date: Mon, 24 Jan 2011 16:17:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nikolai Kondrashov <spbnick@gmail.com>
Cc: Alan Ott <alan@signal11.us>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] HID: Report Descriptor in Sysfs
In-Reply-To: <4D39E69A.5090107@gmail.com>
Message-ID: <alpine.LNX.2.00.1101241615380.5725@pobox.suse.cz>
References: <1295590785-7101-1-git-send-email-alan@signal11.us> <alpine.LNX.2.00.1101211054210.5725@pobox.suse.cz> <4D399DAB.3080808@signal11.us> <alpine.LNX.2.00.1101211607290.5725@pobox.suse.cz> <4D39E69A.5090107@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Nikolai Kondrashov wrote:

> > There were also efforts to make the report descriptor replaceable in a
> > request_firmware() way, but that never converged to state in which it
> > could be applied IIRC.
> I remember seeing messages about it, but couldn't find it.
> Do you have any pointers?
> I'm interesting in seeing if it's worth it and maybe finishing it.

If patchwork woul be working, you'd be able to find it here: 
	
	http://patchwork.kernel.org/patch/69723/

Parts of the thread seem to be on 
http://www.spinics.net/lists/linux-input/msg06537.html

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

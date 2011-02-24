Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1BXSLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 13:11:48 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:33577 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1BXSLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 13:11:45 -0500
Message-ID: <4D669F56.4020303@ahsoftware.de>
Date: Thu, 24 Feb 2011 19:11:34 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>,
        Michael Jones <michael.jones@matrix-vision.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
References: <Pine.LNX.4.44L0.1102241255100.2084-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102241255100.2084-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 24.02.2011 18:57, schrieb Alan Stern:

> It's important that this patch appear in .37-stable at the same time as
> the $SUBJECT patch.  If that means delaying $SUBJECT for one release,
> so be it -- it was not a very important change.

Too late, 2.6.37.1 is already broken. But the patch could be still 
applied to 2.6.32-longterm, at least the message I've replied to asked 
about objections for that version.

Regards,

Alexander

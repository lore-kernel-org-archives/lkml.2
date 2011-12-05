Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab1LEQwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:52:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:56325 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab1LEQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:52:36 -0500
Message-ID: <4EDCF6CF.6020902@linutronix.de>
Date: Mon, 05 Dec 2011 17:52:31 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Shimrit Malichi <smalichi@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        target-devel@vger.kernel.org
Subject: Re: [RFC] UASP on target
References: <Pine.LNX.4.44L0.1112051109040.5138-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112051109040.5138-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 05:10 PM, Alan Stern wrote:

> Evidently you were able to find enough information about the target
> framework to write a driver using it.  Can you tell us where this
> information is?  It hasn't been easy to locate.

Hehe. Well, I've been told that the target framework has everything one
needs to get it done so I've been digging in the code. First I tried to
come up with an easy setup where I can use it. _This_ was already hard
to get done for someone who is not familiar with scsi. Once I had all
pieces together I wrote this [0].With this information I know more or
less how that thing works or should work.
So at this point I understood that I need to comeup with somethin like
tcm_loop or tcm_vhost. Looking at the host side of the uas driver it is
using SAS as the protocol and nothing special if you ignore "struct iu"
for a moment.
Then I found the python script in Documentation/target which creates you 
a skeleton driver. So I used this and started hacking. First I took
the usb descriptors and looked what happens after I connected the
dummy_hcd driver/gadget. I received a usb command message. So now I try 
to wire it up in target. I look at the loopback/vhost_scsi for some
inspiration. Other than that I have no additional information....

[0] http://article.gmane.org/gmane.linux.scsi.target.devel/654

> Alan Stern

Sebastian

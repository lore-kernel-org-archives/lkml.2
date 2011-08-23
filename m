Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1HWTFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:05:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:16035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab1HWTF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:05:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:date:
	mime-version:content-transfer-encoding:from:organization:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=eWm2mR/ZmKfCtRGKmqoxRc8qNmxEdv40k8/bf7xV9Vc6a2KICF86LhEi5804PdenI
	ETFeKBTVJlhknFwCeaylA==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <Pine.LNX.4.44L0.1108231350460.2069-100000@iolanthe.rowland.org>
Date: Tue, 23 Aug 2011 21:05:22 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Message-ID: <op.v0okm8hlvgw7ix@mnazarewicz-glaptop>
In-Reply-To: <Pine.LNX.4.44L0.1108231350460.2069-100000@iolanthe.rowland.org>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 20:00:25 +0200, Alan Stern <stern@rowland.harvard.edu>  
wrote:
> For the time being, perhaps the best answer is to use the _lowest_
> max_speed value among all the function drivers.  It's the simplest
> answer and most likely to be correct most of the time.

In theory, one could create a composite function with only SS/HS
descriptors.  So it would work for SS/HS but not for FS.  I'm not
saying that it would make sense (or that it's not a bug) but that
adds to the discussion.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--

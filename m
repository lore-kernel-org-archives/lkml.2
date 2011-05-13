Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab1EMMKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 08:10:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60375 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1EMMKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 08:10:33 -0400
Message-ID: <7C637C15A1AB48869F938B97BBDF22D8@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Nori, Sekhar" <nsekhar@ti.com>, "Greg KH" <gregkh@suse.de>
Cc: "Greg KH" <greg@kroah.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>,
        "Watkins, Melissa" <m-watkins@ti.com>, <sachi@mistralsolutions.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com> <20110425212056.GA29313@kroah.com> <B85A65D85D7EB246BE421B3FB0FBB593024CAE36A6@dbde02.ent.ti.com> <20110426124519.GC5977@suse.de> <35F38DB5B5C4408EA80AF0DB8A6FA178@subhasishg> <B85A65D85D7EB246BE421B3FB0FBB593024CBA9959@dbde02.ent.ti.com> <0B813DC0439B438BBB2B66A88B1A5F7F@subhasishg> <B85A65D85D7EB246BE421B3FB0FBB593024CE6600F@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024CE6600F@dbde02.ent.ti.com>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Date: Fri, 13 May 2011 17:40:42 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 
>> Say, if the driver is loaded as a module.
>> If I allocate the sram in the platform code, how to I
>> free it when the driver is unloaded. 
> 
> This is what I said in my last e-mail. What is
> the issue you see with this approach?
> 
> | Thanks for the clarification. In this case, the driver
> | should use platform callbacks to get/put fast fifo
> | space. In case this callback is not populated by the
> | platform or returns an error, the driver should fall
> | back to allocating from DDR.
> 

ok, so what you are suggesting is that I implement some
callbacks (like .fifo_alloc, .fifo_dealloc) which can allocate
memory using sram_alloc.
My doubt is, if already such API's are there (by Russel) or you
are suggesting to implement them.
 

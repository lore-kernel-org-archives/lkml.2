Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1FVHP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 03:15:28 -0400
Received: from 93-97-26-182.zone5.bethere.co.uk ([93.97.26.182]:62821 "EHLO
	falkor.sigsegv.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1FVHP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 03:15:27 -0400
X-Greylist: delayed 1770 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jun 2011 03:15:27 EDT
Message-ID: <4E018FA2.4070008@kot-begemot.co.uk>
Date: Wed, 22 Jun 2011 07:45:54 +0100
From: Anton Ivanov <anton.ivanov@kot-begemot.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: I need some help with struct clock_event_device (please cc me)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I need some help with with struct clock_event_device.

Can someone please spare the time to explain to me what exactly is delta in

.set_next_event()

It is probably me being stupid, but I do not get it. If delta is ticks 
(and hence HZ dependent), how is it possible to pass sub-tick values for 
high res timers? If delta is not ticks, exactly what it is and how does 
it depend on shift, mul and other fields in that structure.

Please cc me, I am not subscribed to the list.

-- 
     Humans are allergic to change. They love to say, "We've always
done it this way." I try to fight that. That's why I have a clock
on my wall that runs counter-clockwise.   -- R.A. Grace Hopper

A. R. Ivanov
E-mail:  anton.ivanov@kot-begemot.co.uk


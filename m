Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab0FNVxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:53:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:47737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0FNVxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:53:07 -0400
Message-ID: <4C16A48A.2070404@kernel.org>
Date: Mon, 14 Jun 2010 23:52:10 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-13-git-send-email-tj@kernel.org> <20100614214122.GA21064@suse.de>
In-Reply-To: <20100614214122.GA21064@suse.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 21:52:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/14/2010 11:41 PM, Greg KH wrote:
> So if there's a routing problem, it turns into a polled interrupt?  Do
> we really want that?

Oh yeah, I really want that for libata.  Routing is only part of the
problem and flaky IRQ is something we have to learn to cope with.

> I wonder how long people will run without realizing that there are
> problems with their system if their devices still work.

I think things would be better this way.  If the drives (both cd and
hard) / input devices are not accessible, most people would simply
give up rather than reporting, and many cases are transient problems
which happen only once in the blue moon.

It would be great if some kind of automatic reporting can be used
(similar to kerneloops?).  Hmm... maybe make the warnings scarier?

Thanks.

-- 
tejun

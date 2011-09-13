Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1IMSte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:49:34 -0400
Received: from void.printf.net ([89.145.121.20]:46340 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab1IMStc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:49:32 -0400
From: Chris Ball <cjb@laptop.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org>
	<4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org>
	<4E6FA44F.1050705@goop.org>
Date: Tue, 13 Sep 2011 14:49:25 -0400
In-Reply-To: <4E6FA44F.1050705@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 13 Sep 2011 11:43:27 -0700")
Message-ID: <m2aaa89t1m.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 13 2011, Jeremy Fitzhardinge wrote:
>> If it is running, and not helping, can I persuade you to try a full
>> bisection?
>
> OK, will do.

Thank you!

>>   I don't think we have other reports of this bug, and the
>> only other person who has reported something like it wasn't a kernel
>> hacker.
>
> That's interesting; the X220 is a pretty common machine these days, I
> think.  I wonder if there's variations in the SD controller or something?

I just asked Matthew Garrett to check his X220, and his has the same e823
controller as you, is running a 3.1-rc kernel, and everything's working.

So it's not even variation in the controller model, it's something even
more subtle.  Perhaps try some different cards?  What capacity/speed is
the one you're trying?  If there is a per-card difference, I suppose
we'd expect it to be that slower cards work and faster cards fail
(given the nature of the patch I linked in my last mail).

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

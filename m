Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0CWN7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:59:52 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34578 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753556Ab0CWN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:59:50 -0400
Date: Tue, 23 Mar 2010 14:59:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
Message-ID: <20100323135942.GB1703@ucw.cz>
References: <20100314075831.GA13457@elf.ucw.cz> <hnjjud$k26$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hnjjud$k26$1@dough.gmane.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-14 17:20:13, Bill Davidsen wrote:
> Pavel Machek wrote:
>> Hi!
>>
>> In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
>> thinkpad and geode notebook).
>>
>> On 2.6.34-rc1, hit ^Z and sound starts looping.
>> 									Pavel
> That's not new, I have seen it back as far as 2.6.27.25 doing a suspend 
> in a VM (KVM, no libvirt). But it only happens a few times a year, so I 
> never chased it. I hate to report an occasional problem in an obsolete 
> kernel, and I can't reproduce it.
>
> Does it happen repeatably with the new kernel?

It happened reliably so far, yes.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

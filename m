Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0CWOJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:09:00 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:58980 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0CWOI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:08:59 -0400
Message-ID: <4BA8CB73.80400@ladisch.de>
Date: Tue, 23 Mar 2010 15:08:51 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org
Subject: Re: 2.6.34-rc1: regression: ^Z no longer stops sound
References: <20100314075831.GA13457@elf.ucw.cz> <hnjjud$k26$1@dough.gmane.org> <20100323135942.GB1703@ucw.cz>
In-Reply-To: <20100323135942.GB1703@ucw.cz>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2010-03-14 17:20:13, Bill Davidsen wrote:
>> Pavel Machek wrote:
>>> In 2.6.33, hitting ^Z stopped mpg123 in a way you'd expect (both on
>>> thinkpad and geode notebook).
>>>
>>> On 2.6.34-rc1, hit ^Z and sound starts looping.
>>
>> That's not new, I have seen it back as far as 2.6.27.25 doing a suspend 
>> in a VM (KVM, no libvirt). But it only happens a few times a year, so I 
>> never chased it. I hate to report an occasional problem in an obsolete 
>> kernel, and I can't reproduce it.
>>
>> Does it happen repeatably with the new kernel?
> 
> It happened reliably so far, yes.

This sounds as if the device has been configured to ignore underruns.
What are the contents of /proc/asound/card0/pcm0p/sub0/{sw_params,status}
when it's looping, and when it's really suspended?


Regards,
Clemens

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1KRRNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015Ab1KRRNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:13:21 -0500
Message-ID: <4EC6922D.8010306@redhat.com>
Date: Fri, 18 Nov 2011 12:13:17 -0500
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hook up Ivybridge eDP
References: <1321489780-17085-1-git-send-email-keithp@keithp.com> <1321569940.18123.7.camel@atropine> <yun8vnech3v.fsf@aiko.keithp.com>
In-Reply-To: <yun8vnech3v.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/11 9:13 PM, Keith Packard wrote:
> On Thu, 17 Nov 2011 17:45:40 -0500, Adam Jackson<ajax@redhat.com>  wrote:
>
>> Your silicon people worry me.
>
> In any case, the changes are mostly to move bits around so that there
> are two bits for pipe select

Yeah, the patch looks like it could be correct, just shaking my head.

>> I don't even.  Unless you're looking at some other version of the DP
>> spec than me, I was pretty sure those weren't legal voltage values.  And
>> 3.5dB preemph on 1000mV gives you 1500mV at the peak, which is
>> definitely outside the spec.
>
> I'm just writing down what's in the spec. I don't use these values, just
> the useful ones above.
 >
> You don't happen to have any hardware to test this with, do you?

Not at the moment.  I'll see if I can dig something up though.

- ajax

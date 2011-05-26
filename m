Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab1EZQi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:38:59 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39360 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751748Ab1EZQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:38:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=geoffthorpe.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=O4/A5Q+B4bkK0cgGGrRbwGZCb+XuTjDvsj2ajcxfIYi8OwAVEX4mUX2EGhw/UHVWB4EGFp0q/2rtJsS7aNoiWcGj8wB9dwzB3GDeODMN8PSrsNRxv0+Nn8xVxKabG06i;
Message-ID: <4DDE821D.2010405@geoffthorpe.net>
Date: Thu, 26 May 2011 12:38:53 -0400
From: Geoff Thorpe <geoff@geoffthorpe.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: track "isolated" cpus like other cpu masks.
References: <1305923374-13274-1-git-send-email-geoff@geoffthorpe.net> <1306181649.2497.1.camel@laptop>
In-Reply-To: <1306181649.2497.1.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {1644:host132.hostmonster.com:geofftho:geoffthorpe.com} {sentby:smtp auth 208.111.65.4 authed with geoff@geoffthorpe.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-05-23 04:14 PM, Peter Zijlstra wrote:
> On Fri, 2011-05-20 at 16:29 -0400, Geoff Thorpe wrote:
>> When a subset of cpus have been isolated, it can be useful for subsystems
>> or drivers that have cpu-affinity concerns to have access to this mask
>> (just like the other cpu masks; "possible", "present", "active" and
>> "online"). Eg. to provide specific handling for isolated cpus, or to
>> determine the non-isolated cpus (which is what sched.c uses it for).
>
> Nobody should be using that, isolated CPUs is a 'feature' slated for
> removal.
>

Ah OK, I wasn't aware of that. Consider the patch dropped then.

Thanks,
Geoff


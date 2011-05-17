Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1EQIj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:39:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57234 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1EQIj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:39:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u9guPUnNiffAmdxI3xn/fK/VGLwlMrJP5MXqh/wUH+7HeCz6/t5U1uvR4WjsQO6Yz+
         d1DEN0C2x0ZYkVD+TkBBctvM7OdP3Wuafx8Jklqoos1/7eAuwT6aKZyRBgEFbiHbiYkM
         HfjNOiJTIkklyB1V6aj2zgQwIBdTqI2x++8c0=
Message-ID: <4DD23456.6060400@gmail.com>
Date: Tue, 17 May 2011 10:39:50 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH] Documentation: statistics about nested locks
References: <4DD0F614.2040408@gmail.com> <1305540776.2466.4094.camel@twins> <20110516103559.GA19837@elte.hu>
In-Reply-To: <20110516103559.GA19837@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my mistake with the email client and thanks for the hint!
May I resend a (I hope) corrected version of this small patch with the revision
made by Yong?

On 05/16/2011 12:35 PM, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
>> On Mon, 2011-05-16 at 12:01 +0200, Juri Lelli wrote:
>>> +The graph below shows the relation between the lock functions and the 
>>> various
>>> +hooks therein. 
>>
>> That smells like the patch has whitespace damage..
> 
> Yeah, Documentation/email-clients.txt might help there.
> 
> Thanks,
> 
> 	Ingo

Thanks,

	Juri

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1DOS7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:59:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59214 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1DOS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=TSJw0gvAOvYwvfErNN2ALgFvpRo1QFx/sMg7kO1DMp+13+rrTA+iiOh6ANX3sJm9ud
         ZgoozCEj+k2D9RiVx0YRSTpH9I9jrnmYm3s6qKneOL6rwPumshCqhcmbLoSu1j3UHSwW
         FfGP9dS0NHJeiEucZNEczOSeE70KsmIUdNT3U=
Message-ID: <4DA895A2.4060307@gmail.com>
Date: Fri, 15 Apr 2011 14:59:46 -0400
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Reply-To: alexandre.f.demers@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110411 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org> <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com> <4DA6145D.9070703@kernel.org> <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com> <4DA655E7.3000904@zytor.com> <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com> <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com> <20110415131152.GJ18463@8bytes.org> <4DA8535B.4080901@gmail.com> <20110415142724.GK18463@8bytes.org>
In-Reply-To: <20110415142724.GK18463@8bytes.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-15 10:27 AM, Joerg Roedel wrote:
> On Fri, Apr 15, 2011 at 10:16:59AM -0400, Alexandre Demers wrote:
>> Ok, I'll test it today. Should I apply it on a clean rc3 without any of
>> the other patches?
> Yes, apply it just on -rc3 without any other patch.
>
>> BTW, may I suggest adding the info under bug 33012 in kernel bugzilla?
>> This could be useful in the future.
> Cool, thanks
>
>
> 	Joerg
The patch was applied and tested. It looks fine, I'm able to boot
without problem.

-- 
Alexandre Demers


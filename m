Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1CWPYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:24:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54146 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab1CWPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=M6Cq+c67pnojZwTmUoZRcXf7EcIS7Fqf5w6T6b2FQA+AGj+gQNYuYQFhSmgKeJwZk2
         nSPssti5yPxodB5luETUwmLQeHigiuAODhGkY7y+s3ABwpN+2X+BhboHEtrVFuK2Hy9f
         DV+lIhM3FSaIY9eQvpa5Inb1fWRowqOQhIOz8=
Message-ID: <4D8A10BF.8010406@linaro.org>
Date: Wed, 23 Mar 2011 15:24:47 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        roger.quadros@nokia.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop> <4D8924B6.8040403@linaro.org> <1300842219.2402.309.camel@pasglop> <alpine.LFD.2.00.1103222138320.11889@xanadu.home> <1300850595.2402.320.camel@pasglop> <alpine.LFD.2.00.1103222336030.11889@xanadu.home> <20110323093847.55e9dbba@lxorguk.ukuu.org.uk> <20110323105335.GB778@opensource.wolfsonmicro.com> <20110323150413.GC6284@kroah.com>
In-Reply-To: <20110323150413.GC6284@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 03:04 PM, Somebody in the thread at some point said:
> On Wed, Mar 23, 2011 at 10:53:35AM +0000, Mark Brown wrote:
>> In the specific case of MACs and device names for network adaptors we
>> have userspace solutions which are obscuring the discussion but there
>> are other things which get configured this way which one would usually
>> expect to be handled in kernel.
>
> No, this isn't obsucuring the discussion, it's exactly the point here.
>
> I asked for concrete examples of a need for this type of thing (i.e.
> platform data on USB devices), and this was the only need cited.  I
> then pointed out that this is correctly solved in userspace, as it has
> for other devices like this, and that it's not a valid example of this
> need.
>
> So again, this problem, for this device, has been solved in userspace
> without any kernel changes needed.  If there are other devices that you,

Not sure what you mean by 'again', 'solved in userspace' and so on. 
Your saying: "go away and do it in userspace" is different from it being 
"solved in userspace" in reality.  The mess it would create in userspace 
isn't acceptable.  The outcome of this is it's not fixed in the driver 
nor userspace.

I am currently trying working around it elsewhere in kernel along the 
lines of Alan's idea, since I am not able to fix the actual driver.

-Andy

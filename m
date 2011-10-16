Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1JPJiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 05:38:46 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:47854 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1JPJip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 05:38:45 -0400
X-Greylist: delayed 129309 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Oct 2011 05:38:45 EDT
References: <20111014234055.2265c524.peter@piie.net> <20111014234334.a87a2388.peter@piie.net> <20111015223210.GC16432@liondog.tnic> <cone.1318721291.690132.3813.1000@zopiie> <20111016084300.GB32343@liondog.tnic>
Message-ID: <cone.1318757921.896390.11147.1000@zopiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] acerhdf: Add support for new hardware
Date: Sun, 16 Oct 2011 11:38:41 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov writes:

> On Sun, Oct 16, 2011 at 01:28:11AM +0200, Peter Feuerer wrote: 
>> Borislav Petkov writes:
>> >On Fri, Oct 14, 2011 at 11:43:34PM +0200, Peter Feuerer wrote:
>> >>From: Peter Feuerer <peter@piie.net>
>> >>
>> >>Add support for new hardware:
>> >>Acer Aspire LT-10Q/531/751/1810/1825,
>> >>Acer Travelmate 7730,
>> >>Packard Bell ENBFT/DOTVR46
>> >>
>> >>To prevent from hardware defects, the default temperature values have been
>> >>decreased.
>> >
>> >do you have some actual bug reports stating that the original
>> >temperature values were causing hw defects?
>> 
>> Fortunately not. But due to new supported hardware, of which I don't
>> know the actual temperature limits of processor, harddisk and other
>> components, it just feels safer with this lower settings.
>> 
>> Another point is, that you need to have the "kernelmode=1" option
>> when loading the module to enable fan control. When searching the
>> internet for acerhdf tutorials, you see, everybody not only setting
>> kernelmode=1 but also setting the fanon and fanoff variables. So I
>> think it won't change anything for most people.
>> 
>> Furthermore seems like kernel and userspace tools have been improved
>> to work more efficient and my netbook doesn't get so hot anymore,
>> for me it stays most of the time at about 50 degree when doing
>> office stuff and surfing.
> 
> Ok, good. Sounds to me like this above should be the commit message
> instead of the one sentence you had before because it explains much
> better why you're doing what you're doing with the patch.
> 
> Also, the "add support" part should be another patch because
> conceptually it doesn't belong with the temperature changes.

Okay, will split the patches and resend the series.

Thanks a lot
kind regards,
--peter;

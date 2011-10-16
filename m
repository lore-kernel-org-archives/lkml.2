Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1JPInJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:43:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41566 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab1JPInG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:43:06 -0400
Date: Sun, 16 Oct 2011 10:43:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: mjg@redhat.com, linux-kernel@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] acerhdf: Add support for new hardware
Message-ID: <20111016084300.GB32343@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Feuerer <peter@piie.net>, mjg@redhat.com,
	linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20111014234055.2265c524.peter@piie.net>
 <20111014234334.a87a2388.peter@piie.net>
 <20111015223210.GC16432@liondog.tnic>
 <cone.1318721291.690132.3813.1000@zopiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1318721291.690132.3813.1000@zopiie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 01:28:11AM +0200, Peter Feuerer wrote:
> Hi Boris,
> 
> Borislav Petkov writes:
> >On Fri, Oct 14, 2011 at 11:43:34PM +0200, Peter Feuerer wrote:
> >>From: Peter Feuerer <peter@piie.net>
> >>
> >>Add support for new hardware:
> >>Acer Aspire LT-10Q/531/751/1810/1825,
> >>Acer Travelmate 7730,
> >>Packard Bell ENBFT/DOTVR46
> >>
> >>To prevent from hardware defects, the default temperature values have been
> >>decreased.
> >
> >do you have some actual bug reports stating that the original
> >temperature values were causing hw defects?
> 
> Fortunately not. But due to new supported hardware, of which I don't
> know the actual temperature limits of processor, harddisk and other
> components, it just feels safer with this lower settings.
> 
> Another point is, that you need to have the "kernelmode=1" option
> when loading the module to enable fan control. When searching the
> internet for acerhdf tutorials, you see, everybody not only setting
> kernelmode=1 but also setting the fanon and fanoff variables. So I
> think it won't change anything for most people.
> 
> Furthermore seems like kernel and userspace tools have been improved
> to work more efficient and my netbook doesn't get so hot anymore,
> for me it stays most of the time at about 50 degree when doing
> office stuff and surfing.

Ok, good. Sounds to me like this above should be the commit message
instead of the one sentence you had before because it explains much
better why you're doing what you're doing with the patch.

Also, the "add support" part should be another patch because
conceptually it doesn't belong with the temperature changes.

Thanks.

-- 
Regards/Gruss,
    Boris.

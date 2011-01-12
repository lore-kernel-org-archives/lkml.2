Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1ALLWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 06:22:02 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:59107 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1ALLV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 06:21:59 -0500
Message-ID: <4D2D8ED0.6080807@de.ibm.com>
Date: Wed, 12 Jan 2011 12:21:52 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Icedove/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, James Simmons <jsimmons@infradead.org>
Subject: Re: [git pull] drm for rc1
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
In-Reply-To: <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2011 00:28, schrieb Linus Torvalds:
> On Tue, Jan 11, 2011 at 3:20 PM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>>
>> Now nouveau framebuffer is completely broken on my T61p (01:00.0 VGA compatible controller: nVidia Corporation G84M [Quadro FX 570M] (rev a1))
>> During startup the framebuffer shows only stripes and a blank
>> screen after suspend/resume.
>> I also see lots of TRAP messages. (see below).
>> X11 seems to work fine though...
> 
> Can you try to bisect?

dfe63bb0ad9810db13aab0058caba97866e0a681 is the first bad commit
commit dfe63bb0ad9810db13aab0058caba97866e0a681
Author: James Simmons <jsimmons@infradead.org>
Date:   Thu Dec 23 16:40:37 2010 +0000

    drm: Update fbdev fb_fix_screeninfo


Reverting this on top of todays git also fixes my problem.

Christian

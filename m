Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1LUN5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 08:57:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44334 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1LUN5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 08:57:43 -0500
MIME-Version: 1.0
In-Reply-To: <1324455480.1807.153.camel@thor.local>
References: <lx6sezwGldO.A.IhF.UBpWOB@chimera>
	<201112210039.14100.linux-pm-bounces@lists.linux-foundation.org>
	<1324455480.1807.153.camel@thor.local>
Date: Wed, 21 Dec 2011 08:57:42 -0500
Message-ID: <CADnq5_PYxp5Ud3oXNyJFWFmkE8Dhd54Qz1L4eCNRT1wyM=NioQ@mail.gmail.com>
Subject: Re: 3.2-rc6+: Reported regressions from 3.0 and 3.1
From: Alex Deucher <alexdeucher@gmail.com>
To: =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>
Cc: Bob Tracy <rct@gherkin.frus.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/21 Michel Dänzer <michel@daenzer.net>:
> On Mit, 2011-12-21 at 00:39 +0100, Rafael J. Wysocki wrote:
>>
>> Subject    : [BUG] 3.2-rcX radeon KMS system freeze
>> Submitter  : Bob Tracy <rct@gherkin.frus.com>
>> Date       : 2011-11-25 20:33
>> Message-ID : 20111125203351.GA3651@gherkin.frus.com
>> References : http://marc.info/?l=linux-kernel&m=132225331312019&w=2
>
> Is that really a (recent) regression? It sounds like Bob's only getting
> things working for the first time, and I can't see any mention of a
> previous working kernel version.
>
> Anyway, might be worth following up on this on the dri-devel list with
> more information, e.g. the dmesg output and Xorg.0.log corresponding to
> the freeze.

Has KMS or recent mesa even been tested on Alpha?  If anything it
seems like it's probably a mesa bug rather than a kernel bug as it
seems to lock up when the desktop effects are loaded.

Alex

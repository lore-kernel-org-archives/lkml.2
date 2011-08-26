Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1HZGh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:37:59 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55064 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1HZGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <4E552B01.7090109@linux.intel.com>
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
	<20110824001137.GA23979@somewhere>
	<CAFWT=83FNbAHUtPiouD3R06LEze5w1Mv07EL-x9VxSs_EXuruA@mail.gmail.com>
	<20110824135852.GE23979@somewhere>
	<4E5513FA.6060904@linux.intel.com>
	<CAJL_dMug+L0oQjeDs_3Xs2s2=-_3ci-Ab5-iDS8Up5u-xbaHiw@mail.gmail.com>
	<CAFWT=80YV-+-COSfGnuDTSxqy17kgXCQpCVJD1b2yif_nM=1Yg@mail.gmail.com>
	<4E552B01.7090109@linux.intel.com>
Date: Fri, 26 Aug 2011 02:37:57 -0400
Message-ID: <CAFWT=80GXa208WHrF4GBdcPz8aYHyJii-L-OauaGSNtoqCk4GA@mail.gmail.com>
Subject: Re: Bug Report for Linux Kernel 3.x
From: Steevven1 <steevven1@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anca Emanuel <anca.emanuel@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:46 PM, Arjan van de Ven
<arjan@linux.intel.com> wrote:
> On 8/24/2011 9:44 AM, Steevven1 wrote:
>
>> VERY interesting! The second link seems to imply that Phoronix has
>> independently found this same bug that we've been talking about in my
>> originally-linked ubuntuforums discussion. Specifically, the
>> interesting quote is:
>>
>> "Besides the new Linux 3.1 kernel power regression, there's also a
>> power regression introduced in the Linux 3.0 kernel that has
>> previously not been talked about on Phoronix. The Linux 3.0 power draw
>> is up by 24% over the Linux 2.6.39 kernel."
>
>
> sounds like good news; a 24% regression is MUCH easier to bisect than a
> 0.05% regression ;-)
>
>


Is there any news on this bug, or is there an official kernel.org
place to track it?

Here are the only other two places I know of where this bug is being tracked:
http://ubuntuforums.org/showthread.php?t=1822629 (as linked before)
https://bugs.launchpad.net/ubuntu/+bug/834037 (Ubuntu bug tracking system)

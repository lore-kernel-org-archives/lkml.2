Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab1HXQrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 12:47:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:44231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1HXQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 12:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41459809"
Message-ID: <4E552B01.7090109@linux.intel.com>
Date: Wed, 24 Aug 2011 09:46:57 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Steevven1 <steevven1@gmail.com>
CC: Anca Emanuel <anca.emanuel@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bug Report for Linux Kernel 3.x
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com> <20110824001137.GA23979@somewhere> <CAFWT=83FNbAHUtPiouD3R06LEze5w1Mv07EL-x9VxSs_EXuruA@mail.gmail.com> <20110824135852.GE23979@somewhere> <4E5513FA.6060904@linux.intel.com> <CAJL_dMug+L0oQjeDs_3Xs2s2=-_3ci-Ab5-iDS8Up5u-xbaHiw@mail.gmail.com> <CAFWT=80YV-+-COSfGnuDTSxqy17kgXCQpCVJD1b2yif_nM=1Yg@mail.gmail.com>
In-Reply-To: <CAFWT=80YV-+-COSfGnuDTSxqy17kgXCQpCVJD1b2yif_nM=1Yg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/2011 9:44 AM, Steevven1 wrote:

> VERY interesting! The second link seems to imply that Phoronix has
> independently found this same bug that we've been talking about in my
> originally-linked ubuntuforums discussion. Specifically, the
> interesting quote is:
>
> "Besides the new Linux 3.1 kernel power regression, there's also a
> power regression introduced in the Linux 3.0 kernel that has
> previously not been talked about on Phoronix. The Linux 3.0 power draw
> is up by 24% over the Linux 2.6.39 kernel."


sounds like good news; a 24% regression is MUCH easier to bisect than a 
0.05% regression ;-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2DWOoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:44:55 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:47116 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab2DWOoy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120423142717.GA32380@kroah.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com> <20120412030044.GA26236@kroah.com>
 <CAM=4YEQ6_+7xPwi2jucks1P9p8tO3cSG7S0s=VVJVrueb4fB=g@mail.gmail.com>
 <C8443D0743D26F4388EA172BF4E2A7A93E96E7C5@DBDE01.ent.ti.com>
 <CAMQu2gz2CD+-kcSF2HVGWWrjk3DmsGgcuucBXan5NqtVUSwa2w@mail.gmail.com> <20120423142717.GA32380@kroah.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Mon, 23 Apr 2012 20:14:30 +0530
Message-ID: <CAMQu2gxoP8qOT6DP_QJkNVyTp3uzVYgbkJuNz7k9fx4fh2iPmg@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
To: Greg KH <greg@kroah.com>
Cc: "Mohammed, Afzal" <afzal@ti.com>, "V, Aneesh" <aneesh@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hunter, Jon" <jon-hunter@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 7:57 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Apr 23, 2012 at 04:34:46PM +0530, Shilimkar, Santosh wrote:
>> Afzal,
>>
>> On Mon, Apr 23, 2012 at 4:26 PM, Mohammed, Afzal <afzal@ti.com> wrote:
>> > Hi Aneesh,
>> >
>> > On Fri, Apr 13, 2012 at 01:28:55, V, Aneesh wrote:
>> >
>> >> Thanks. I will wait for your review then. Once I have your comments
>> >> I will re-work and submit in the new directory structure proposed.
>> >
>> > Do you have a plan on submitting EMIF driver in the new proposed
>> > (drivers/memory) directory. Or shall I submit GPMC driver by creating
>> > the new "memory" directory.
>> >
>>  Greg mentioned that he plans to do a review of EMIF driver. We were waiting
>> for his comments before sending the updated series.
>
> No, don't wait for me, please resend, I was waiting for you :)

Thanks Greg !!
Will start working on updating the patch set and post it on list.

Regards
Santosh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2JODVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 23:21:31 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53940 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2JODVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 23:21:30 -0400
MIME-Version: 1.0
In-Reply-To: <20121014100130.GM12801@game.jcrosoft.org>
References: <2039bc164224b0068bc078b6cd8df6218e754fce.1350051925.git.viresh.kumar@linaro.org>
	<20121012144837.GE12801@game.jcrosoft.org>
	<CAKohpo=vMchmiz70evBB5bPqt4O4DWUocd5M1o9gc8fsY_Fkiw@mail.gmail.com>
	<20121012162148.GH12801@game.jcrosoft.org>
	<CAKohpok5ZOmz9CCJbTGc=_tncxnZYEW7UMh2FcFcs0dB87JAcQ@mail.gmail.com>
	<20121013064422.GJ12801@game.jcrosoft.org>
	<CAKohpokfei_ryGKMh4wE9D=wyRZCkddc+Da1cq+3facTHradKQ@mail.gmail.com>
	<20121013122242.GL12801@game.jcrosoft.org>
	<CAKohpom-P+=QfVNBsypq70+o+z_5J63RD72DA-_CakTM9LDCNA@mail.gmail.com>
	<CAKohpokj0Up23YEDTuSOHDgqcCuM3Q21cwnkAz5Ya=JhPKM98A@mail.gmail.com>
	<20121014100130.GM12801@game.jcrosoft.org>
Date: Mon, 15 Oct 2012 08:51:29 +0530
Message-ID: <CAKohpo=H4YoHd+c5kuT8dSkGMy0BOoTb=dwdf1=MxStbUZUMRg@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] ARM: SPEAr13xx: Pass DW DMAC platform data from DT
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: andriy.shevchenko@linux.intel.com, vinod.koul@intel.com,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2012 15:31, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 19:40 Sat 13 Oct     , Viresh Kumar wrote:
>> On 13 October 2012 19:38, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> > On 13 October 2012 17:52, Jean-Christophe PLAGNIOL-VILLARD
>> > <plagnioj@jcrosoft.com> wrote:
>> >> On 14:18 Sat 13 Oct     , Viresh Kumar wrote:
>> >>>    On Oct 13, 2012 12:16 PM, "Jean-Christophe PLAGNIOL-VILLARD"
>> >>>    <plagnioj@jcrosoft.com> wrote:
>> >>>    >
>> >>>    > On 22:42 Fri 12 Oct     , Viresh Kumar wrote:
>> >>>    > > On 12 October 2012 21:51, Jean-Christophe PLAGNIOL-VILLARD
>> >>>    > > <plagnioj@jcrosoft.com> wrote:
>> >>>    > > >> >> +     OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL,
>> >>>    "cf"),
>> >>>    > > >> > ?/
>> >>>    > > >>
>> >>>    > > >> Sorry. can't get it :(
>> >>>    > > > what is the "cf" as paltfrom data
>> >>>    > >
>> >>>    > > This is dma bus_id string, which matches with what is passed from dtb.
>> >>>    > so pass if via dtb too
>> >>>
>> >>>    Yes. Already passed in 13xx.dtsi.
>>
>> Probably some confusion here. What i meant to say here is, dmac's
>> DT slave info has a node for cf and cf driver expects this string to come
>> via platform data currently.
>
> so use a phandle to connect them

The purpose of this patchset wasn't to fix how CF driver sends its filter
routine and its parameter. CF driver would be fixed later by ST guys.

--
viresh

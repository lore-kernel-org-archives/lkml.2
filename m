Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2JMOIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:08:22 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35521 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2JMOIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <20121013122242.GL12801@game.jcrosoft.org>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350051925.git.viresh.kumar@linaro.org>
	<2039bc164224b0068bc078b6cd8df6218e754fce.1350051925.git.viresh.kumar@linaro.org>
	<20121012144837.GE12801@game.jcrosoft.org>
	<CAKohpo=vMchmiz70evBB5bPqt4O4DWUocd5M1o9gc8fsY_Fkiw@mail.gmail.com>
	<20121012162148.GH12801@game.jcrosoft.org>
	<CAKohpok5ZOmz9CCJbTGc=_tncxnZYEW7UMh2FcFcs0dB87JAcQ@mail.gmail.com>
	<20121013064422.GJ12801@game.jcrosoft.org>
	<CAKohpokfei_ryGKMh4wE9D=wyRZCkddc+Da1cq+3facTHradKQ@mail.gmail.com>
	<20121013122242.GL12801@game.jcrosoft.org>
Date: Sat, 13 Oct 2012 19:38:18 +0530
Message-ID: <CAKohpom-P+=QfVNBsypq70+o+z_5J63RD72DA-_CakTM9LDCNA@mail.gmail.com>
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

On 13 October 2012 17:52, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 14:18 Sat 13 Oct     , Viresh Kumar wrote:
>>    On Oct 13, 2012 12:16 PM, "Jean-Christophe PLAGNIOL-VILLARD"
>>    <plagnioj@jcrosoft.com> wrote:
>>    >
>>    > On 22:42 Fri 12 Oct     , Viresh Kumar wrote:
>>    > > On 12 October 2012 21:51, Jean-Christophe PLAGNIOL-VILLARD
>>    > > <plagnioj@jcrosoft.com> wrote:
>>    > > >> >> +     OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL,
>>    "cf"),
>>    > > >> > ?/
>>    > > >>
>>    > > >> Sorry. can't get it :(
>>    > > > what is the "cf" as paltfrom data
>>    > >
>>    > > This is dma bus_id string, which matches with what is passed from dtb.
>>    > so pass if via dtb too
>>
>>    Yes. Already passed in 13xx.dtsi.
> so why do you keep the AUXDATA

Because the compact flash driver expects it via platform data and not
via DT. yes, it
can be changed, but that wasn't the target of this patchset. If it has
to be done, then
it has to be done separately by ST guys.

--
viresh

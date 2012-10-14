Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2JNKLx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:11:53 -0400
Received: from 5.mo3.mail-out.ovh.net ([87.98.178.36]:35698 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843Ab2JNKLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:11:51 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2012 06:11:51 EDT
Date: Sun, 14 Oct 2012 12:01:30 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: andriy.shevchenko@linux.intel.com, vinod.koul@intel.com,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH V2 3/3] ARM: SPEAr13xx: Pass DW DMAC platform data from
 DT
Message-ID: <20121014100130.GM12801@game.jcrosoft.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokj0Up23YEDTuSOHDgqcCuM3Q21cwnkAz5Ya=JhPKM98A@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10233304254334544667
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:40 Sat 13 Oct     , Viresh Kumar wrote:
> On 13 October 2012 19:38, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 13 October 2012 17:52, Jean-Christophe PLAGNIOL-VILLARD
> > <plagnioj@jcrosoft.com> wrote:
> >> On 14:18 Sat 13 Oct     , Viresh Kumar wrote:
> >>>    On Oct 13, 2012 12:16 PM, "Jean-Christophe PLAGNIOL-VILLARD"
> >>>    <plagnioj@jcrosoft.com> wrote:
> >>>    >
> >>>    > On 22:42 Fri 12 Oct     , Viresh Kumar wrote:
> >>>    > > On 12 October 2012 21:51, Jean-Christophe PLAGNIOL-VILLARD
> >>>    > > <plagnioj@jcrosoft.com> wrote:
> >>>    > > >> >> +     OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL,
> >>>    "cf"),
> >>>    > > >> > ?/
> >>>    > > >>
> >>>    > > >> Sorry. can't get it :(
> >>>    > > > what is the "cf" as paltfrom data
> >>>    > >
> >>>    > > This is dma bus_id string, which matches with what is passed from dtb.
> >>>    > so pass if via dtb too
> >>>
> >>>    Yes. Already passed in 13xx.dtsi.
> 
> Probably some confusion here. What i meant to say here is, dmac's
> DT slave info has a node for cf and cf driver expects this string to come
> via platform data currently.

so use a phandle to connect them

Best Regards,
J.

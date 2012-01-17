Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2AQRWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:22:25 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16140 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2AQRWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:22:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Jan 2012 09:20:48 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Michal Marek <mmarek@suse.cz>, Mark Salter <msalter@redhat.com>
CC: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        Russell King <linux@arm.linux.org.uk>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Date: Tue, 17 Jan 2012 09:20:47 -0800
Subject: RE: [PATCH 2/2] Kbuild: Use dtc's -d (dependency) option
Thread-Topic: [PATCH 2/2] Kbuild: Use dtc's -d (dependency) option
Thread-Index: AczTDxFVLSiyp/uKTym2sv4Hw0OW7ACLOWHg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D2255@HQMAIL01.nvidia.com>
References: <1326134295-15547-1-git-send-email-swarren@nvidia.com>
  <1326134295-15547-2-git-send-email-swarren@nvidia.com>
 <1326310587.2535.291.camel@deneb.redhat.com> <4F1206F1.5090405@suse.cz>
In-Reply-To: <4F1206F1.5090405@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek wrote at Saturday, January 14, 2012 3:51 PM:
> On 11.1.2012 20:36, Mark Salter wrote:
> > On Mon, 2012-01-09 at 11:38 -0700, Stephen Warren wrote:
> >> This hooks dtc into Kbuild's dependency system.
> >>
> >> Thus, for example, "make dtbs" will rebuild tegra-harmony.dtb if only
> >> tegra20.dtsi has changed yet tegra-harmony.dts has not. The previous
> >> lack of this feature recently caused me to have very confusing "git
> >> bisect" results.
> >>
> >> For ARM, it's obvious what to add to $(targets). I'm not familiar enough
> >> with other architectures to know what to add there. Powerpc appears to
> >> already add various .dtb files into $(targets), but the other archs may
> >> need something added to $(targets) to work.
> >>
> >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> >>
> >
> > Acked-by: Mark Salter <msalter@redhat.com>
> >
> > For the arch/c6x bit.
> 
> As the C6X port has been merged in this merge window, I can't easily
> apply this patch to my kbuild branch and at the same time please Linus
> by basing the pull request on a tagged release. So I'm going to drop the
> arch/c6x part to keep the kbuild branch "pretty" and let either Mark or
> Stephen send the patch to Linus directly, once he has merged the kbuild
> branch. Would that work?

I was assuming my patches were for 3.4 rather than 3.3, since it's pretty
late for new features in 3.3. In that case, there wouldn't be an issue,
right?

If you do want to go ahead and push my patches into 3.3, your proposal
looks fine to me. Mark, do you want me to push the patch to Linus, or
do you want to pick it up?

Thanks.

-- 
nvpublic


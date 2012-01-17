Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab2AQS1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:27:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab2AQS1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:27:23 -0500
Subject: RE: [PATCH 2/2] Kbuild: Use dtc's -d (dependency) option
From: Mark Salter <msalter@redhat.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Michal Marek <mmarek@suse.cz>, Jon Loeliger <jdl@jdl.com>,
        David Gibson <david@gibson.dropbear.id.au>,
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
Date: Tue, 17 Jan 2012 13:26:06 -0500
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D2255@HQMAIL01.nvidia.com>
References: <1326134295-15547-1-git-send-email-swarren@nvidia.com>
	 <1326134295-15547-2-git-send-email-swarren@nvidia.com>
	 <1326310587.2535.291.camel@deneb.redhat.com> <4F1206F1.5090405@suse.cz>
	 <74CDBE0F657A3D45AFBB94109FB122FF17801D2255@HQMAIL01.nvidia.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1326824773.20239.12.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 09:20 -0800, Stephen Warren wrote:
> Michal Marek wrote at Saturday, January 14, 2012 3:51 PM:
> > On 11.1.2012 20:36, Mark Salter wrote:
> > > On Mon, 2012-01-09 at 11:38 -0700, Stephen Warren wrote:
> > >> This hooks dtc into Kbuild's dependency system.
> > >>
> > >> Thus, for example, "make dtbs" will rebuild tegra-harmony.dtb if only
> > >> tegra20.dtsi has changed yet tegra-harmony.dts has not. The previous
> > >> lack of this feature recently caused me to have very confusing "git
> > >> bisect" results.
> > >>
> > >> For ARM, it's obvious what to add to $(targets). I'm not familiar enough
> > >> with other architectures to know what to add there. Powerpc appears to
> > >> already add various .dtb files into $(targets), but the other archs may
> > >> need something added to $(targets) to work.
> > >>
> > >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > >>
> > >
> > > Acked-by: Mark Salter <msalter@redhat.com>
> > >
> > > For the arch/c6x bit.
> > 
> > As the C6X port has been merged in this merge window, I can't easily
> > apply this patch to my kbuild branch and at the same time please Linus
> > by basing the pull request on a tagged release. So I'm going to drop the
> > arch/c6x part to keep the kbuild branch "pretty" and let either Mark or
> > Stephen send the patch to Linus directly, once he has merged the kbuild
> > branch. Would that work?
> 
> I was assuming my patches were for 3.4 rather than 3.3, since it's pretty
> late for new features in 3.3. In that case, there wouldn't be an issue,
> right?
> 
> If you do want to go ahead and push my patches into 3.3, your proposal
> looks fine to me. Mark, do you want me to push the patch to Linus, or
> do you want to pick it up?

It would probably be best to keep it all together, but if there's a need
to break out c6x individually, I don't mind picking it up.

--Mark



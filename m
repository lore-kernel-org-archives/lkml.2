Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2ARKIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:08:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193Ab2ARKIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:08:09 -0500
Message-ID: <4F1699FE.5050005@suse.cz>
Date: Wed, 18 Jan 2012 11:07:58 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
Cc: Mark Salter <msalter@redhat.com>, Jon Loeliger <jdl@jdl.com>,
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
Subject: Re: [PATCH 2/2] Kbuild: Use dtc's -d (dependency) option
References: <1326134295-15547-1-git-send-email-swarren@nvidia.com>  <1326134295-15547-2-git-send-email-swarren@nvidia.com> <1326310587.2535.291.camel@deneb.redhat.com> <4F1206F1.5090405@suse.cz> <74CDBE0F657A3D45AFBB94109FB122FF17801D2255@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D2255@HQMAIL01.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.1.2012 18:20, Stephen Warren wrote:
> Michal Marek wrote at Saturday, January 14, 2012 3:51 PM:
>> As the C6X port has been merged in this merge window, I can't easily
>> apply this patch to my kbuild branch and at the same time please Linus
>> by basing the pull request on a tagged release. So I'm going to drop the
>> arch/c6x part to keep the kbuild branch "pretty" and let either Mark or
>> Stephen send the patch to Linus directly, once he has merged the kbuild
>> branch. Would that work?
> 
> I was assuming my patches were for 3.4 rather than 3.3, since it's pretty
> late for new features in 3.3. In that case, there wouldn't be an issue,
> right?

OK, that was a misunderstanding then. I applied it to the kbuild branch
for 3.3 and Linus pulled it in the meantime. It's not a terribly
intrusive change, after all.

Michal

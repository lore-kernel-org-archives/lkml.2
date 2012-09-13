Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2IMFvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:51:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19675 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541Ab2IMFvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:51:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 12 Sep 2012 22:51:40 -0700
From: Alex Courbot <acourbot@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
Date: Thu, 13 Sep 2012 14:53:25 +0900
Message-ID: <3370354.JQqCLmZLM6@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.1 (Linux/3.5.3-1-ARCH; KDE/4.9.1; x86_64; ; )
In-Reply-To: <20120912213355.GA3342@lizard>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <5050FE28.2080502@wwwdotorg.org> <20120912213355.GA3342@lizard>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012 05:33:56 Anton Vorontsov wrote:
> On Wed, Sep 12, 2012 at 03:27:04PM -0600, Stephen Warren wrote:
> 
> > On 09/12/2012 03:57 AM, Alexandre Courbot wrote:
> > 
> > > New revision of the power sequences, taking as usual the feedback that
> > > was
> > > kindly provided about the last version.
> > > 
> > > I think now is a good time to discuss integrating this and to start
> > > looking for a maintainer who would be willing to merge this into
> > > his/her tree (I am especially thinking about the power framework
> > > maintainers, since this is where the code is right now.
> > 
> > 
> > The other alternative is for you to maintain this going forward; I
> > believe that would be as simple as:
> > 
> > * Create a patch to add yourself to MAINTAINERS for the
> > drivers/power/power_seq/ directory.
> > 
> > * Get a kernel.org account, push this patch to a branch there, and add
> > the branch into linux-next.
> > 
> > * Send a pull request to Linus at the appropriate time.
> > 
> > * Ongoing: Accept any patches, perform any maintenance required, etc.
> > 
> > Does anyone see any issue with Alexandre doing this? Nobody else has
> > volunteered yet:-)
> 
> 
> Yup, looks like the best way.

I am fine this way too - it will just take some time for me to get ready as I 
will need to get my GPG key signed by some kernel developers first (that's what 
I forgot to do during the last LinuxCon!). I know a few here so it should not 
be too hard to get them drunk and sign my key, but I don't expect to be ready 
for the 3.7 merge window. Would anybody be concerned by this delay? By the 
meantime I can also make a branch available somewhere.

Alex.


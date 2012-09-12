Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2ILVgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:36:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55075 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2ILVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:36:32 -0400
Date: Wed, 12 Sep 2012 14:33:56 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-fbdev@vger.kernel.org, linux-pm@vger.kernel.org,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
Message-ID: <20120912213355.GA3342@lizard>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
 <5050FE28.2080502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5050FE28.2080502@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 03:27:04PM -0600, Stephen Warren wrote:
> On 09/12/2012 03:57 AM, Alexandre Courbot wrote:
> > New revision of the power sequences, taking as usual the feedback that was
> > kindly provided about the last version.
> > 
> > I think now is a good time to discuss integrating this and to start looking for
> > a maintainer who would be willing to merge this into his/her tree (I am
> > especially thinking about the power framework maintainers, since this is where
> > the code is right now.
> 
> The other alternative is for you to maintain this going forward; I
> believe that would be as simple as:
> 
> * Create a patch to add yourself to MAINTAINERS for the
> drivers/power/power_seq/ directory.
> 
> * Get a kernel.org account, push this patch to a branch there, and add
> the branch into linux-next.
> 
> * Send a pull request to Linus at the appropriate time.
> 
> * Ongoing: Accept any patches, perform any maintenance required, etc.
> 
> Does anyone see any issue with Alexandre doing this? Nobody else has
> volunteered yet:-)

Yup, looks like the best way.

Anton.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2KVSws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:52:48 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56290 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2KVSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:52:45 -0500
MIME-Version: 1.0
In-Reply-To: <20121121151209.GA4048@avionic-0098.adnet.avionic-design.de>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com> <20121120215429.B621F3E1821@localhost>
 <13540495.epaCf4JVn9@percival> <50ACB59B.4090404@iki.fi> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de>
 <50ACC341.3090204@ti.com> <20121121130039.GA12191@avionic-0098.adnet.avionic-design.de>
 <50ACD7DC.5060405@ti.com> <CAAVeFuJofYwj926=3v0ApBCq_vNhCdC1PnzDc-B3d=LL_L40Uw@mail.gmail.com>
 <20121121151209.GA4048@avionic-0098.adnet.avionic-design.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Nov 2012 13:39:57 +0000
X-Google-Sender-Auth: vcr7Q-2_d7l6rIUr0nGFEz4r74c
Message-ID: <CACxGe6tSp=YDDO28Edu4ZO1y96mdnK69ujM=dC=9LExw_FKrbQ@mail.gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Tomi Valkeinen <tomba@iki.fi>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 3:12 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Thu, Nov 22, 2012 at 12:02:47AM +0900, Alexandre Courbot wrote:
>> Mmmm so maybe I am misinterpreting things, but it looks like we
>> have just buried the power sequences here, haven't we?
>
> I don't think so. In fact I was just starting to think that maybe for
> Tegra we could have a generic panel driver which used power sequences
> to abstract away the pin differences for powering up the panel. Since
> most likely that will be where the differences are there is a lot of
> potential to factor things out into sequences.
>
> Perhaps what we may want to postpone for now is the DT representation
> since that's what Tomi and Grant seem to be mostly opposed to.

Don't give up. I'm am being cautions and trying to think of all the
implications because that is what I have to do as a maintainer. I'm
not opposed to the feature but I need a good level of confidence that
it has been fully thought out.

g.

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

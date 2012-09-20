Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2ITKch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:32:37 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:55785 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2ITKcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:32:36 -0400
Date: Thu, 20 Sep 2012 12:32:22 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/11] pinctrl: mvebu: pinctrl driver
Message-ID: <20120920123222.7f58ee4c@skate>
In-Reply-To: <20120920100254.GE21928@lunn.ch>
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<CACRpkda+Kav6RGstSQ9+BCgVV+pR6ca_HmoueODYubX_xYM8Jw@mail.gmail.com>
	<505AD103.8050004@gmail.com>
	<20120920110424.3cb4daff@skate>
	<20120920100254.GE21928@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew Lunn,

On Thu, 20 Sep 2012 12:02:54 +0200, Andrew Lunn wrote:

> > Hum, which patches are stalling the integration into the Marvell tree?
> 
> l2 cache, I think.
> 
> The trees Jason built for pull requests in the direction of arm-soc
> had the l2 cache patch as the very first in the series. Now that these
> patches have run into some trouble, its blocking all the patches that
> followed.
> 
> Jason is re-building his trees, throwing out l2 cache for the
> moment. That should allow Olof/Arnd to pull these trees into arm-soc,
> and then Jason will work on integrating the remaining patches not
> already in his trees.

Ok, thanks. Regarding the L2 cache patches, Grégory has replied to
Russell comments, and will most likely post an updated version late
next week. So it would be good if the pinctrl/gpio patches could get
merged.

Also, Andrew, could you look at the address decoding patch set I have
sent? I really would like to see that in 3.7 if possible. Thanks!

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

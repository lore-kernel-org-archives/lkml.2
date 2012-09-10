Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2IJXl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:41:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46395 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab2IJXlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:41:55 -0400
Date: Tue, 11 Sep 2012 07:41:46 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Daniel Mack <zonque@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: gpio-regulator: add DT bindings
Message-ID: <20120910234145.GA30699@opensource.wolfsonmicro.com>
References: <1347289429-18713-1-git-send-email-zonque@gmail.com>
 <504E4234.9090300@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504E4234.9090300@wwwdotorg.org>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 01:40:36PM -0600, Stephen Warren wrote:
> On 09/10/2012 09:03 AM, Daniel Mack wrote:

> > + - "enabled-at-boot":		If set, the regulator has been enabled at boot
> > +				time

> Isn't that regulator-boot-on, as defined in regulator.txt that you
> mentioned?

It's slightly different due to our unfortunate inability to support
GPIO readback for output GPIOs - this means the regualtor is enabled at
boot and the driver should use that to bootstrap state, the core one
means the regulator should be turned on at boot.  The latter would force
the regulator to be be enabled during boot.

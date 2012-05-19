Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2ESGGd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:06:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49743 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2ESGGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:06:31 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 2/5] netdev: mdio-octeon.c: Convert to use device tree.
To: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1335489630-27017-3-git-send-email-ddaney.cavm@gmail.com>
References: <1335489630-27017-1-git-send-email-ddaney.cavm@gmail.com> <1335489630-27017-3-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 00:06:28 -0600
Message-Id: <20120519060628.D3D0B3E046E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 18:20:27 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Get the MDIO bus controller addresses from the device tree, small
> clean up in use of devm_*
> 
> Remove, now unused, platform device setup code.

Ditto on this one (and the others); make sure the new compatible value
is documented.  Otherwise looks good.

g.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2KIW7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:59:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46813 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2KIW7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:59:41 -0500
Message-ID: <509D8ADA.6040408@wwwdotorg.org>
Date: Fri, 09 Nov 2012 15:59:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices
 to mach-omap2)
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <02FF5400-9F97-4B8A-AEF0-267B01C8099F@antoniou-consulting.com> <CAD=GYpbeKtW37Cj9cXr8F7F83d9Fgs-moqu9p6cOaPE1VxwbSg@mail.gmail.com>
In-Reply-To: <CAD=GYpbeKtW37Cj9cXr8F7F83d9Fgs-moqu9p6cOaPE1VxwbSg@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 10:32 PM, Joel A Fernandes wrote:
...
> Alternatively to hashing, reading David Gibson's paper I followed,
> phandle is supposed to 'uniquely' identity node. I wonder why the node
> name itself is not sufficient to uniquely identify. The code that does
> the tree walking can then just strcmp the node name while it walks the
> tree instead of having to find a node with a phandle number.

Node names or node paths?

If you're talking node names, consider an SoC with two different I2C
controllers each attached to an I2C EEPROM with the same I2C address.
The nodes representing those EEPROMs might both get the name "eeprom@2c"
for example. The node paths should be unique though.


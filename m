Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0G0Bhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 21:37:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33878
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab0G0Bhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 21:37:52 -0400
Date: Mon, 26 Jul 2010 18:38:08 -0700 (PDT)
Message-Id: <20100726.183808.15223674.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sam@ravnborg.org, sfr@canb.auug.org.au, monstr@monstr.eu,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        benh@kernel.crashing.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default
 of_node_to_nid()
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikpON7WUkTLrnW4y2kghM=H8cLCAFst08S3cL_Z@mail.gmail.com>
References: <AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com>
	<20100726.154854.35052662.davem@davemloft.net>
	<AANLkTikpON7WUkTLrnW4y2kghM=H8cLCAFst08S3cL_Z@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Jul 2010 16:51:01 -0600

> Indeed.  I looked at it briefly, but it wasn't immediately clear what
> the impact would be to switch powerpc over to -1, and it looked to me
> like sparc depends on -1 to signify no node association.

Kernel wide, NUMA interfaces tend to take "-1" to mean "any node."

I had looked over the powerpc cases, and besides 1 or 2 strange
locations the powerpc call sites were ready to handle -1.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab0G0B5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 21:57:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51743 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0G0B5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 21:57:38 -0400
MIME-Version: 1.0
In-Reply-To: <20100726.183808.15223674.davem@davemloft.net>
References: <AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com> 
	<20100726.154854.35052662.davem@davemloft.net> <AANLkTikpON7WUkTLrnW4y2kghM=H8cLCAFst08S3cL_Z@mail.gmail.com> 
	<20100726.183808.15223674.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Jul 2010 19:57:17 -0600
X-Google-Sender-Auth: 1UzqRGbK4ITRZp7ESho3REwrexE
Message-ID: <AANLkTi=Kw78W0zuuQ0vzO7rXXVkTDf0D5w8n44hV_FWt@mail.gmail.com>
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default 
	of_node_to_nid()
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, sfr@canb.auug.org.au, monstr@monstr.eu,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        benh@kernel.crashing.org, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 7:38 PM, David Miller <davem@davemloft.net> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Mon, 26 Jul 2010 16:51:01 -0600
>
>> Indeed.  I looked at it briefly, but it wasn't immediately clear what
>> the impact would be to switch powerpc over to -1, and it looked to me
>> like sparc depends on -1 to signify no node association.
>
> Kernel wide, NUMA interfaces tend to take "-1" to mean "any node."
>
> I had looked over the powerpc cases, and besides 1 or 2 strange
> locations the powerpc call sites were ready to handle -1.

Okay, well let me rework the patch to make -1 the default and let
powerpc override it.  A follow-on patch can fix up the powerpc usage
of 0.

g.

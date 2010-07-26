Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab0GZWsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:48:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58146
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755684Ab0GZWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:48:37 -0400
Date: Mon, 26 Jul 2010 15:48:54 -0700 (PDT)
Message-Id: <20100726.154854.35052662.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sam@ravnborg.org, sfr@canb.auug.org.au, monstr@monstr.eu,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        benh@kernel.crashing.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3] of: Create asm-generic/of.h and provide default
 of_node_to_nid()
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com>
References: <20100726220405.1550.63442.stgit@angua>
	<20100726222627.GA23501@merkur.ravnborg.org>
	<AANLkTikcV3jJUm_My-oK-drudSDz3M2iH1cWhxdt+W1s@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Jul 2010 16:42:20 -0600

> It protects against some later include file doing a #define
> of_node_to_nid and thus resulting in an inconsistent definition.  If
> some code tries to do this then the preprocessor will complain.  This
> is the pattern that Stephen suggested.

Also, it would be nice to unravel the "0" vs. "-1" default
inconsistency.

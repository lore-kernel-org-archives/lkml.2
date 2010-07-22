Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab0GVF2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:28:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51089
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286Ab0GVF2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:28:35 -0400
Date: Wed, 21 Jul 2010 22:28:52 -0700 (PDT)
Message-Id: <20100721.222852.08977036.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, benh@kernel.crashing.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, sparclinux@vger.kernel.org
Subject: Re: [PATCH 5/5] of: remove asm/of_device.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100721234015.7782.98378.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
	<20100721234015.7782.98378.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:40:15 -0600

> It is mostly unused now.  Sparc has a few defines left in it, but they
> can be moved to other headers.  Removing this header means that new
> architectures adding CONFIG_OF support don't need to also add this
> header file.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>

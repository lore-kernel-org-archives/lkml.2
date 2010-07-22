Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0GVF2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:28:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51048
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078Ab0GVF17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:27:59 -0400
Date: Wed, 21 Jul 2010 22:28:15 -0700 (PDT)
Message-Id: <20100721.222815.04681231.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, benh@kernel.crashing.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, sparclinux@vger.kernel.org
Subject: Re: [PATCH 0/5] Eliminate of_platform_bus_type
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100721232817.7782.23410.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:39:49 -0600

> David, you'll also want to take a look at patches 4 & 5 to see if you
> agree with my decisions on where I move symbols in the header files.

Looks fine to me.

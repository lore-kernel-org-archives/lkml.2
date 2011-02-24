Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1BYIOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:14:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab1BYIOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:14:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 13/15] dt/serial: Eliminate users of of_platform_{, un}register_driver
Date: Thu, 24 Feb 2011 17:34:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        davem@davemloft.net, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6> <20110223043442.20795.4037.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043442.20795.4037.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241734.25048.arnd@arndb.de>
X-Provags-ID: V02:K0:jfp34lTGhGceD/LkfdQMdhCq/91aaKotyDbJIxCW7R0
 qPfufnuntSZKnJ6bjhKNU465YfoBQe+MFbDpS0mhQaneN1vMyA
 tcCB83yvbNZ0KLXIF/j28W/NJZgjx3hi1blswmv3k1O/ZZ1Kdz
 +6mkvcGVCgDbkJydDs5yv7/jUUNp5qnqLiSKravEl7EEFSsNfs
 J66ybPQaPUR39ZiqpYogQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 February 2011, Grant Likely wrote:
> Get rid of users of of_platform_driver in drivers/serial.  The
> of_platform_{,un}register_driver functions are going away, so the
> users need to be converted to using the platform_bus_type directly.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

of_serial changes look good.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>


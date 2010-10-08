Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab0JHSwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:52:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55695
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689Ab0JHSwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:52:04 -0400
Date: Fri, 08 Oct 2010 11:52:26 -0700 (PDT)
Message-Id: <20101008.115226.179923658.davem@davemloft.net>
To: dilinger@queued.net
Cc: grant.likely@secretlab.ca, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] sparc: stop exporting openprom.h header
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101008113424.2249c2df@debxo>
References: <20101008173650.GH3863@angua.secretlab.ca>
	<20101008.104557.59696706.davem@davemloft.net>
	<20101008113424.2249c2df@debxo>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andres Salomon <dilinger@queued.net>
Date: Fri, 8 Oct 2010 11:34:24 -0700

> 
> It's unknown why openprom.h was being exported; there doesn't seem to be any
> reason for it currently, and it creates headaches with userspace being able
> to potentially use the structures in there.  So, don't export it anymore.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Acked-by: David S. Miller <davem@davemloft.net>

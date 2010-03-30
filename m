Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0C3UHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:07:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35429
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518Ab0C3UH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:07:29 -0400
Date: Tue, 30 Mar 2010 13:07:27 -0700 (PDT)
Message-Id: <20100330.130727.119993073.davem@davemloft.net>
To: stefan.bader@canonical.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: patch sparc64-make-prom-entry-spinlock-nmi-safe.patch added to
 2.6.32-stable tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BB1E98E.9050702@canonical.com>
References: <12689584863184@kroah.org>
	<4BB1E98E.9050702@canonical.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Bader <stefan.bader@canonical.com>
Date: Tue, 30 Mar 2010 14:07:42 +0200

> This converted the raw_spinlock usage which is used in the upstream patch but
> not available in 2.6.32 to normal spinlock usage. Should it get annotated to
> document that?

I don't think so.

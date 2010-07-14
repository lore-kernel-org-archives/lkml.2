Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0GNUhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:37:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49273
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757022Ab0GNUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:37:30 -0400
Date: Wed, 14 Jul 2010 13:37:45 -0700 (PDT)
Message-Id: <20100714.133745.226784358.davem@davemloft.net>
To: siccegge@cs.fau.de
Cc: adobriyan@gmail.com, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 06/11] Removing dead CHELSIO_T1_COUGAR
From: David Miller <davem@davemloft.net>
In-Reply-To: <f46378f51fe7128f755f6cb324a85e958106e3be.1279110895.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
	<f46378f51fe7128f755f6cb324a85e958106e3be.1279110895.git.siccegge@cs.fau.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 14 Jul 2010 14:41:04 +0200

> CHELSIO_T1_COUGAR doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

This has already been eliminated in the net-next-2.6 by other
changes.

Thanks.

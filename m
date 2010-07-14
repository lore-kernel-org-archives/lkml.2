Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab0GNUgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:36:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48301
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017Ab0GNUgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:36:11 -0400
Date: Wed, 14 Jul 2010 13:36:25 -0700 (PDT)
Message-Id: <20100714.133625.193700456.davem@davemloft.net>
To: siccegge@cs.fau.de
Cc: adobriyan@gmail.com, jpirko@redhat.com, joe@perches.com,
        shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 05/11] Removing dead CASSINI_NAPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <582064a9d6be5cc6f620884ed5120ceb21fdbb12.1279110895.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
	<582064a9d6be5cc6f620884ed5120ceb21fdbb12.1279110895.git.siccegge@cs.fau.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 14 Jul 2010 14:40:59 +0200

> CASSINI_NAPI doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Applied.

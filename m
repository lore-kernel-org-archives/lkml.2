Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0GNTSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:18:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43567
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029Ab0GNTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:18:33 -0400
Date: Wed, 14 Jul 2010 12:18:48 -0700 (PDT)
Message-Id: <20100714.121848.39171257.davem@davemloft.net>
To: siccegge@cs.fau.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 03/11] Removing dead CASSINI_QGE_DEBUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <f44daaa9771dd77f0d351aac327436ebad005fa3.1279110894.git.siccegge@cs.fau.de>
References: <cover.1279110894.git.siccegge@cs.fau.de>
	<f44daaa9771dd77f0d351aac327436ebad005fa3.1279110894.git.siccegge@cs.fau.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Egger <siccegge@cs.fau.de>
Date: Wed, 14 Jul 2010 14:39:58 +0200

> CASSINI_QGE_DEBUG doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Applied, thanks.

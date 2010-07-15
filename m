Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0GOB1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:27:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41665
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758093Ab0GOB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:27:04 -0400
Date: Wed, 14 Jul 2010 18:27:19 -0700 (PDT)
Message-Id: <20100714.182719.260098958.davem@davemloft.net>
To: chihau@gmail.com
Cc: tj@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Net: ethernet: pe2.c: fix EXPORT_SYMBOL macro code
 style issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1279139074-13040-1-git-send-email-chihau@gmail.com>
References: <1279139074-13040-1-git-send-email-chihau@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>
Date: Wed, 14 Jul 2010 16:24:34 -0400

> From: Chihau Chau <chihau@gmail.com>
> 
> This patch fix a code style issuei, if a function is exported, the
> EXPORT_SYMBOL macro for it should follow immediately after the closing
> function brace line.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

Applied.

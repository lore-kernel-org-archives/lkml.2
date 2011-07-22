Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1GVEfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 00:35:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:48138 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1GVEfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 00:35:13 -0400
Date: Thu, 21 Jul 2011 21:35:07 -0700 (PDT)
Message-Id: <20110721.213507.1929766655763148125.davem@davemloft.net>
To: cascardo@holoscopio.com
Cc: wg@grandegger.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        srcvale@holoscopio.com
Subject: Re: [PATCH] can: make function can_get_bittiming static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311301351-5298-1-git-send-email-cascardo@holoscopio.com>
References: <1311301351-5298-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 21 Jul 2011 21:35:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Date: Thu, 21 Jul 2011 23:22:31 -0300

> The function can_get_bittiming is not used anywhere else, so it should be
> static.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Applied.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0KVThG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 14:37:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38360
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807Ab0KVThE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 14:37:04 -0500
Date: Mon, 22 Nov 2010 11:37:29 -0800 (PST)
Message-Id: <20101122.113729.59693099.davem@davemloft.net>
To: mk@lab.zgora.pl
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: fix use after free in ide-acpi
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290454478-5443-1-git-send-email-mk@lab.zgora.pl>
References: <1290454478-5443-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <mk@lab.zgora.pl>
Date: Mon, 22 Nov 2010 20:34:38 +0100

> out_obj points to kfreed memory and we dereference that pointer in
> DEBPRINT/printk.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Applied, thanks.

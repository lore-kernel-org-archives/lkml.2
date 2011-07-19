Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1GSJJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:09:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58021 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab1GSJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:09:29 -0400
Subject: Re: [PATCH]drivers:net:Kconfig
From: Eric Dumazet <eric.dumazet@gmail.com>
To: wangyanqing <udknight@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20110719090014.GA5455@udknight>
References: <20110719090014.GA5455@udknight>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 11:09:19 +0200
Message-ID: <1311066559.2375.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 19 juillet 2011 à 17:00 +0800, wangyanqing a écrit :
> Broadcom Tigon3 driver tg3.ko can't work without the Broadcom PHY,
>  so maybe we should add a dependence on it.Or at least we should add
>  notice in the help txt.
> 

Thats strange.

Here I have a (running) tg3 adapter, but

$ zgrep BROADCOM /proc/config.gz
# CONFIG_BROADCOM_PHY is not set

Could you elaborate ?



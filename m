Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0HCFC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:02:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51192
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074Ab0HCFC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:02:57 -0400
Date: Mon, 02 Aug 2010 22:03:15 -0700 (PDT)
Message-Id: <20100802.220315.124065662.davem@davemloft.net>
To: henrique.camargo@ensitec.com.br
Cc: chaithrika@ti.com, srk@ti.com, khilman@deeprootsystems.com,
        jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, segooon@gmail.com
Subject: Re: [PATCH] Fixes a typo from "dev" to "ndev"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1280805042.2089.6.camel@lemming>
References: <AANLkTiko540hMAUhaJr5mNKzFK2-vBOTZmEOxZWZv7ci@mail.gmail.com>
	<20100730.222034.183058824.davem@davemloft.net>
	<1280805042.2089.6.camel@lemming>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrique Camargo <henrique.camargo@ensitec.com.br>
Date: Tue, 03 Aug 2010 00:10:42 -0300

> The typo was causing compilation errors since "dev" was not defined.
> 
> Signed-off-by: Henrique Camargo <henrique.camargo@ensitec.com.br>

Applied, thank you.

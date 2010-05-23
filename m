Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0EWIyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 04:54:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35635
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686Ab0EWIyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 04:54:17 -0400
Date: Sun, 23 May 2010 01:54:26 -0700 (PDT)
Message-Id: <20100523.015426.00037797.davem@davemloft.net>
To: tj@kernel.org
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] pci: disable MSI on VIA K8M800
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BF8E5DF.6030408@kernel.org>
References: <4BF8E5DF.6030408@kernel.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Sun, 23 May 2010 10:22:55 +0200

> MSI delivery from on-board ahci controller doesn't work on K8M800.  At
> this point, it's unclear whether the culprit is with the ahci
> controller or the host bridge.  Given the track record and considering
> the rather minimal impact of MSI, disabling it seems reasonable.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Rainer Hurtado Navarro <publio.escipion.el.africano@gmail.com>
> Cc: stable@kernel.org
> ---
> Maybe we should whitelist working ones from via rather than the other
> way around.  :-(

Correctness first, of course, but saying the impact of MSI is minimal
ignores the fact that no hardware multiqueue networking at all is
possible without it. :-)


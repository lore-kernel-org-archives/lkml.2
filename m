Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab0FQBFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 21:05:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56269
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755518Ab0FQBFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 21:05:36 -0400
Date: Wed, 16 Jun 2010 18:05:47 -0700 (PDT)
Message-Id: <20100616.180547.200372207.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: netdev@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, tklein@linux.ibm.com, adetsch@br.ibm.com,
       themann@de.ibm.com
Subject: Re: [PATCH 2/2] ehea: Fix kernel deadlock in DLPAR-mem processing
From: David Miller <davem@davemloft.net>
In-Reply-To: <201006151735.43144.ossthema@de.ibm.com>
References: <201006151735.43144.ossthema@de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jan-Bernd Themann" <ossthema@de.ibm.com>
Date: Tue, 15 Jun 2010 17:35:42 +0200

> Port reset operations and memory add/remove operations need to 
> be serialized to avoid a kernel deadlock. The deadlock is caused
> by calling the napi_disable() function twice.
> Therefore we have to employ the dlpar_mem_lock in the ehea_reset_port
> function as well
> 
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

Applied.

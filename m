Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0CWBd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:33:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59939
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756675Ab0CWBdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:33:23 -0400
Date: Mon, 22 Mar 2010 18:33:46 -0700 (PDT)
Message-Id: <20100322.183346.215539298.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] netconsole: do not depend on experimental
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100322100305.5518.29500.sendpatchset@localhost.localdomain>
References: <20100322100305.5518.29500.sendpatchset@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 22 Mar 2010 05:59:23 -0400

> 
> Nowadays, most distributions enable netconsole by default,
> including RHEL, Fedora, Debian, Arch, Opensuse. And
> we don't have any bug reports about it. So I think there
> is no need to mark it as experimental any more.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: WANG Cong <amwang@redhat.com>

Applied.

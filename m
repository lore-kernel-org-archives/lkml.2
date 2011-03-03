Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1CCGQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:16:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55852
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353Ab1CCGQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:16:30 -0500
Date: Wed, 02 Mar 2011 22:17:07 -0800 (PST)
Message-Id: <20110302.221707.260068518.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, fubar@us.ibm.com, netdev@vger.kernel.org
Subject: Re: [Patch] bonding: move procfs into bond_procfs.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298896204-6521-1-git-send-email-amwang@redhat.com>
References: <1298896204-6521-1-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 28 Feb 2011 20:30:04 +0800

> bond_main.c is bloating, separate the procfs code out,
> move them to bond_procfs.c
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Please use Makefile rules to conditionally compile the new bond_procfs.o
file, instead of wrapping almost the entire file with an ifdef.

Put the dummy no-PROC_FS function stubs, as inlines, in bonding.h

Thanks!

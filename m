Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2GIVtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:49:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59551 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab2GIVtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:49:33 -0400
Date: Mon, 09 Jul 2012 14:49:32 -0700 (PDT)
Message-Id: <20120709.144932.243254122059983829.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: dilip.daya@hp.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        serge@hallyn.com
Subject: Re: [PATCH 2/2] bonding: debugfs and network namespaces are
 incompatible
From: David Miller <davem@davemloft.net>
In-Reply-To: <87sjd03bdw.fsf_-_@xmission.com>
References: <20120706194741.GA22113@mail.hallyn.com>
	<87y5ms3bfi.fsf_-_@xmission.com>
	<87sjd03bdw.fsf_-_@xmission.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 09 Jul 2012 13:52:43 -0700

> 
> The bonding debugfs support has been broken in the presence of network
> namespaces since it has been added.  The debugfs support does not handle
> multiple bonding devices with the same name in different network
> namespaces.
> 
> I haven't had any bug reports, and I'm not interested in getting any.
> Disable the debugfs support when network namespaces are enabled.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Applied.

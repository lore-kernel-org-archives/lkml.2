Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab2KESJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:09:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48349 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2KESJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:09:19 -0500
Date: Mon, 05 Nov 2012 13:09:17 -0500 (EST)
Message-Id: <20121105.130917.2098838777626057548.davem@davemloft.net>
To: georgezhang@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 0/6] VSOCK for Linux upstreaming
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121105175730.21472.99155.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121105175730.21472.99155.stgit@promb-2n-dhcp175.eng.vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The big and only question is whether anyone can actually use any of
this stuff without your proprietary bits?

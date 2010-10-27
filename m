Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab0J0A67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:58:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44142 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760748Ab0J0A65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <20101027112904.461a0143.sfr@canb.auug.org.au>
References: <20101027112904.461a0143.sfr@canb.auug.org.au>
Date: Tue, 26 Oct 2010 17:58:55 -0700
Message-ID: <AANLkTimyUzz1Bf+FsYjoRdL80mCB83cq_qoBUupJJ92i@mail.gmail.com>
Subject: Re: linux-next: build warning from Linus' tree
From: Jesse Gross <jesse@nicira.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 5:29 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> While building Linus' tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
>
> drivers/net/igb/igb_main.c: In function 'igb_xmit_frame_ring_adv':
> drivers/net/igb/igb_main.c:4110: warning: unused variable 'adapter'
>
> Introduced by commit eab6d18d20fc5b5ba04a7e7fcd6f357197870e51 ("vlan:
> Don't check for vlan group before vlan_tx_tag_present").

Patch sent out to resolve this.

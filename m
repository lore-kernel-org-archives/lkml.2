Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1GTQTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:19:50 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42624 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752512Ab1GTQTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:19:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cyv4BvWQ1QXWf8gEJeQRmRKgfOawNj0dN4CaKcY7x/mWJUN2apjK/ibM73FziRjo5co1Nn8Z4Ta06NiWAxmiV9WjSkcDTjRhV7++Xsyq/eOTJPc5lHjRwKk1wRUx7d5/;
Date: Wed, 20 Jul 2011 09:19:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-driver@qlogic.com
Subject: Re: linux-next: Tree for July 20 (qlcnic)
Message-Id: <20110720091945.39f0a8a5.rdunlap@xenotime.net>
In-Reply-To: <20110720180041.5774ca335e6697c17374dca5@canb.auug.org.au>
References: <20110720180041.5774ca335e6697c17374dca5@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011 18:00:41 +1000 Stephen Rothwell wrote:

> Hi all,

When CONFIG_VLAN_8021Q is not enabled:

drivers/net/qlcnic/qlcnic_main.c:4207: error: 'struct net_device' has no member named 'vlgrp'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

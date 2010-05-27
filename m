Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0E0XN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:13:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56545
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755411Ab0E0XN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:13:26 -0400
Date: Thu, 27 May 2010 16:13:36 -0700 (PDT)
Message-Id: <20100527.161336.189713948.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, krkumar2@in.ibm.com
Subject: Re: [GIT PULL net-2.6] vhost-net: error handling fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100527115714.GA7899@redhat.com>
References: <20100527115714.GA7899@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 27 May 2010 14:57:14 +0300

> David,
> The following tree includes fixes dealing with error handling
> in vhost-net. It is on top of net-2.6.
> Please merge it for 2.6.35.
> Thanks!
> 
> The following changes since commit 8a74ad60a546b13bd1096b2a61a7a5c6fd9ae17c:
> 
>   net: fix lock_sock_bh/unlock_sock_bh (2010-05-27 00:30:53 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net

Pulled, thanks Michael.

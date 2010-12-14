Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0LNFsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 00:48:08 -0500
Received: from ozlabs.org ([203.10.76.45]:38212 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab0LNFsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 00:48:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [GIT PULL net-next-2.6] vhost-net: tools, cleanups, optimizations
Date: Tue, 14 Dec 2010 16:18:03 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; i686; ; )
Cc: David Miller <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101213104413.GA678@redhat.com> <20101213172447.GA8560@redhat.com>
In-Reply-To: <20101213172447.GA8560@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141618.03567.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 03:54:47 am Michael S. Tsirkin wrote:
> On Mon, Dec 13, 2010 at 12:44:13PM +0200, Michael S. Tsirkin wrote:
> > Please merge the following tree for 2.6.38.
> > Thanks!
> 
> Um, I sent this out before I noticed the mail from Rusty
> with some questions on the test code. I missed that and
> assumed no comments -> no issues, perhaps wrongly.
> 
> Rusty - I tried answering the questions there - any issues
> with merging this? It's just a test so won't be hard to remove
> later if it's not helpful ...

Traditionally this stuff has not gone in tree.  However, I think it
should be...

Rusty.

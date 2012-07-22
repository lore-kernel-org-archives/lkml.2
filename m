Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab2GVUes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 16:34:48 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:43997 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2GVUer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 16:34:47 -0400
Subject: Re: [PULL] vhost-net changes for net/3.6
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        asias@redhat.com, pbonzini@redhat.com, stefanha@gmail.com,
        stefanha@linux.vnet.ibm.com, wuzhy@cn.ibm.com,
        Greg KH <gregkh@linuxfoundation.org>
In-Reply-To: <20120722.121942.2002727319293471163.davem@davemloft.net>
References: <20120721225436.GA23519@redhat.com>
	 <20120722.121942.2002727319293471163.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Jul 2012 13:34:44 -0700
Message-ID: <1342989284.25472.227.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi DaveM,

On Sun, 2012-07-22 at 12:19 -0700, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 22 Jul 2012 01:54:36 +0300
> 
> > The following changes since commit 186e868786f97c8026f0a81400b451ace306b3a4:
> > 
> >   forcedeth: spin_unlock_irq in interrupt handler fix (2012-07-20 16:18:36 -0700)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git vhost-net-next
> > 
> > for you to fetch changes up to 163049aefdc04323a2d17ec9f2862027b43b0502:
> > 
> >   vhost: make vhost work queue visible (2012-07-22 01:22:23 +0300)
> 
> Pulled, thanks.

So target-pending/for-next-merge will need to be rebased once these bits
hit mainline for the tcm_vhost initial merge commit..

Just curious when your planning on sending out a -rc1 PULL request for
net-next..?

--nab






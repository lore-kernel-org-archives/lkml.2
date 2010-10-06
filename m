Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab0JFUKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:10:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40046
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756687Ab0JFUKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:10:45 -0400
Date: Wed, 06 Oct 2010 13:11:06 -0700 (PDT)
Message-Id: <20101006.131106.39196569.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jasowang@redhat.com
Subject: Re: [GIT PULL net-next-2.6] vhost-net patchset for 2.6.37
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101005182732.GA25796@redhat.com>
References: <20101005182732.GA25796@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 5 Oct 2010 20:27:32 +0200

> It looks like it was a quiet cycle for vhost-net:
> probably because most of energy was spent on bugfixes
> that went in for 2.6.36.
> People are working on multiqueue, tracing but I'm not
> sure it'll get done in time for 2.6.37 - so here's
> a tree with a single patch that helps windows guests
> which we definitely want in the next kernel.
> 
> Please merge for 2.6.37.

Pulled, thanks Michael.

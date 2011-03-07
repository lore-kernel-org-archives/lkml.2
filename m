Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1CGCDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:03:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39859
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab1CGCDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:03:02 -0500
Date: Sun, 06 Mar 2011 18:03:39 -0800 (PST)
Message-Id: <20110306.180339.193718218.davem@davemloft.net>
To: mst@redhat.com
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: copy_from_user -> __copy_from_user
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110306113349.GA24333@redhat.com>
References: <20110306113349.GA24333@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 6 Mar 2011 13:33:49 +0200

> copy_from_user is pretty high on perf top profile,
> replacing it with __copy_from_user helps.
> It's also safe because we do access_ok checks during setup.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Is Rusty going to take this or should I?

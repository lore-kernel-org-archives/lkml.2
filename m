Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0F3VaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:30:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49256
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726Ab0F3VaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:30:01 -0400
Date: Wed, 30 Jun 2010 14:30:14 -0700 (PDT)
Message-Id: <20100630.143014.134109550.davem@davemloft.net>
To: mst@redhat.com
Cc: arozansk@redhat.com, herbert.xu@redhat.com, quintela@redhat.com,
       kvm@vger.kernel.org, virtualization@lists.osdl.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, ykaul@redhat.com,
       markmc@redhat.com
Subject: Re: [PATCHv2] vhost-net: add dhclient work-around from userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100629130439.GD3603@redhat.com>
References: <20100628100807.GA30685@redhat.com>
	<20100629.003647.214219303.davem@davemloft.net>
	<20100629130439.GD3603@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 29 Jun 2010 16:04:39 +0300

> Since using the module involves updating the management tools
> as well, if we go down this route it will be much less painful
> for everyone to do push it upstream.

Ok, you can make your case to Patrick McHardy and if he'll merge
it into his netfilter GIT tree I guess I'll have to take it :)

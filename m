Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab0KOQpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:45:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55782
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757990Ab0KOQpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:45:45 -0500
Date: Mon, 15 Nov 2010 08:46:09 -0800 (PST)
Message-Id: <20101115.084609.71124618.davem@davemloft.net>
To: kaber@trash.net
Cc: eparis@redhat.com, hzhong@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH] network: return errors if we know tcp_connect
 failed
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CE16198.7000709@trash.net>
References: <1289836066.14282.7.camel@localhost.localdomain>
	<4CE15885.90003@trash.net>
	<4CE16198.7000709@trash.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 15 Nov 2010 17:36:40 +0100

> Patch for demonstration purposes attached. I've modified the
> MARK target so it returns NF_DROP with an errno code of
> -ECONNREFUSED:

I'm fine with the tcp_output.c changes.

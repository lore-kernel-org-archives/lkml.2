Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab1CRTqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:46:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51350
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284Ab1CRTqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:46:33 -0400
Date: Fri, 18 Mar 2011 12:47:11 -0700 (PDT)
Message-Id: <20110318.124711.116396341.davem@davemloft.net>
To: segoon@openwall.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peak@argo.troja.mff.cuni.cz, solar@openwall.com,
        kees.cook@canonical.com, dan.j.rosenberg@gmail.com, eugene@redhat.com,
        nelhage@ksplice.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCH] net: ipv4: add IPPROTO_ICMP socket kind
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110318180002.GA30912@albatros>
References: <20110318180002.GA30912@albatros>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Fri, 18 Mar 2011 21:00:02 +0300

> This patch adds IPPROTO_ICMP socket kind.

I kindly asked the other day for people to not submit new feature
patches while we are amidst the merge window:

http://marc.info/?l=linux-netdev&m=130023005214910&w=2

Please, if you want to do networking development, pay attention to
such important announcements which decreases the burdon upon me and
makes everything operate more smoothly.

Thanks.

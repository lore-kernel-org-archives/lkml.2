Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1ITPEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:04:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab1ITPEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:04:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1315383059-3673-9-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-9-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, Torben Hohn <torbenh@gmx.de>
Subject: Re: [PATCH 08/62] frv: irq: Remove IRQF_DISABLED
Date: Tue, 20 Sep 2011 16:03:54 +0100
Message-ID: <2015.1316531034@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang <yong.zhang0@gmail.com> wrote:

> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>

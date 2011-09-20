Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1ITPGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:06:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1ITPGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:06:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1315383059-3673-16-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-16-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@elte.hu, Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-am33-list@redhat.com
Subject: Re: [PATCH 15/62] mn10300: irq: Remove IRQF_DISABLED
Date: Tue, 20 Sep 2011 16:04:53 +0100
Message-ID: <2063.1316531093@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang <yong.zhang0@gmail.com> wrote:

> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: David Howells <dhowells@redhat.com>

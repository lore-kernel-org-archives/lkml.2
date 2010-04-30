Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab0D3RDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:03:42 -0400
Received: from tex.lwn.net ([70.33.254.29]:41549 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932553Ab0D3RDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:03:31 -0400
Date: Fri, 30 Apr 2010 09:39:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Bruno =?ISO-8859-1?B?UHLpbW9udA==?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [RFC] Second OLPC Viafb series, v2
Message-ID: <20100430093924.3d92fa59@bike.lwn.net>
In-Reply-To: <20100429192613.5385c501@neptune.home>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
	<20100429192613.5385c501@neptune.home>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 19:26:13 +0200
Bruno Prémont <bonbons@linux-vserver.org> wrote:

> Testing here, loading path seems to work fine (console mode) as well as
> mode switching with fbset, but rmmod viafb fails with below trace.

OK, it looks like gpiochip_remove() is not meant to be called with IRQs
disabled.  That's easily fixed.  Thanks for testing!

jon

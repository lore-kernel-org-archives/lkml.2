Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0INN1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:27:49 -0400
Received: from tex.lwn.net ([70.33.254.29]:40284 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab0INN1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:27:48 -0400
Date: Tue, 14 Sep 2010 07:27:46 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Add sc16is7x2 driver
Message-ID: <20100914072746.4dad4e34@bike.lwn.net>
In-Reply-To: <4C8F7381.50300@iis.fraunhofer.de>
References: <4C80F419.5070601@iis.fraunhofer.de>
	<20100913172544.a81e8422.akpm@linux-foundation.org>
	<4C8F7381.50300@iis.fraunhofer.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 15:07:13 +0200
Manuel Stahl <manuel.stahl@iis.fraunhofer.de> wrote:

> Where can I find some example how to use the new threaded irqs?

Basic description here: http://lwn.net/Articles/302043/

If you grep request_threaded_irq() in drivers/, you'll certainly find
some real-world examples.

jon

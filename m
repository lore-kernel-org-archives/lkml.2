Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0IOTRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 15:17:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753710Ab0IOTRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 15:17:39 -0400
Date: Wed, 15 Sep 2010 12:17:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Add sc16is7x2 driver
Message-Id: <20100915121729.19864d88.akpm@linux-foundation.org>
In-Reply-To: <4C90CD36.6020602@iis.fraunhofer.de>
References: <4C80F419.5070601@iis.fraunhofer.de>
	<20100913172544.a81e8422.akpm@linux-foundation.org>
	<4C8F7381.50300@iis.fraunhofer.de>
	<20100914072746.4dad4e34@bike.lwn.net>
	<4C90CD36.6020602@iis.fraunhofer.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 15:42:14 +0200
Manuel Stahl <manuel.stahl@iis.fraunhofer.de> wrote:

> OK, here is an implementation with threaded irqs.

That simplified things nicely.  Does it still work?

> Still not sure about 
> the locking stuff. Maybe someone experienced with uart drivers can help?

The question is too general for anyone to answer, really.  Please
describe the specific issues in resonable detail?  



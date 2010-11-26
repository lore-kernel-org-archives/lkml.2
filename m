Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0KZVi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:38:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:45515 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab0KZVi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:38:56 -0500
Subject: Re: [PATCH 04/11] x86/dtb: add irq host abstraction
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jon Loeliger <jdl@jdl.com>, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CEFC1EC.7030507@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-5-git-send-email-bigeasy@linutronix.de>
	 <E1PLhWV-0004y7-44@jdl.com>  <4CEFC1EC.7030507@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 08:36:12 +1100
Message-ID: <1290807372.32570.137.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 15:19 +0100, Sebastian Andrzej Siewior wrote:
> AFAIK Benh was thinking about renaming it. I don't know if this is
> still
> the case or when he intends to do so. Once he does so, this can be
> renamed
> as well. 

That and moving the powerpc code to a generic place so you don't have to
re-invent your own :-)

I think Grant has patches for that.

Cheers,
Ben.



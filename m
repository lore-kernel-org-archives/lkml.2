Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2DFKMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 06:12:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:38133 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2DFKMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 06:12:37 -0400
Date: Fri, 6 Apr 2012 12:12:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Torben Hohn <torbenh@linutronix.de>
Subject: Re: [PATCH] gpio/sodaville: Convert sodaville driver to new
 irqdomain API
Message-ID: <20120406101236.GD5734@linutronix.de>
References: <1332968546-12901-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1332968546-12901-1-git-send-email-grant.likely@secretlab.ca>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2012-03-28 15:02:26 [-0600]:

>Hi guys,
Hi Grant,

sorry for the long delay.

>This patch fixes the build failure for the sodaville driver, but I've got
>no way to test it.  Please take a look before I merge it.

It looks good. I don't have the board around and I haven't get around to
look at the irq host changes. However, you can add my acked-by while
merging.

>g.

Sebastian

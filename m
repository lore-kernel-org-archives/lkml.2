Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab0D3T1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:27:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57280 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756977Ab0D3T0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:26:53 -0400
Date: Fri, 30 Apr 2010 20:32:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] stallion: prune lock_kernel calls
Message-ID: <20100430203226.460366e5@lxorguk.ukuu.org.uk>
In-Reply-To: <201004292329.27799.arnd@arndb.de>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
	<20100401160504.8882.37742.stgit@localhost.localdomain>
	<201004292329.27799.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This won't work because brdp->state is an 'unsigned int' variable, while
> bitops only work on 'unsigned long'.

32bit x86 only code - but I have now updated the patch to fix this bug

> Maybe you sent out a wrong version of this file?

No it seems I forgot to build the stallion driver when testing the
patches. 

Alan

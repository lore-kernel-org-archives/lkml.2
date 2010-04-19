Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0DSO1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:27:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46859 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203Ab0DSO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:27:21 -0400
Date: Mon, 19 Apr 2010 15:31:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] vt: deactive Shift In/Out in unicode mode
Message-ID: <20100419153136.3585281f@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 15:57:52 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> Hi,
> 
> 
> 
> I am proposing the patch below for inclusion.
> Also pullable via
> 	git://dev.medozas.de/linux siso

It seems to do a lot of other things as well. Can you split out just the
relevant bit ?


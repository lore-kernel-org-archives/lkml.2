Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab0FPLLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:11:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45357 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754111Ab0FPLLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:11:48 -0400
Date: Wed, 16 Jun 2010 12:15:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Yao <shiningarcanine@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does the kernel page the CFS's red-black tree nodes?
Message-ID: <20100616121517.1e66f06f@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTilOK580U03orIO6jcMvzrHeNsykLSMkdlw0hZLI@mail.gmail.com>
References: <AANLkTilfw_rXQ4P1jRnrOtun2c9kAq6zNEQHxTF124_x@mail.gmail.com>
	<AANLkTilOK580U03orIO6jcMvzrHeNsykLSMkdlw0hZLI@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel doesn't page its own data structures (there a couple of
exceptional cases). That avoids the entire nightmare of trying to have
partly paged kernels, the resulting priority inversions and all the other
horrors you can get plus the big overheads from it.

Alan

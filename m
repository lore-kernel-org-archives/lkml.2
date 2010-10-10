Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0JJJH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 05:07:26 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44679 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab0JJJHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 05:07:25 -0400
Date: Sun, 10 Oct 2010 02:09:05 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] sparc: make drivers/of/pdt.c no longer sparc-only
Message-ID: <20101010020905.1e27c1b4@debxo>
In-Reply-To: <20101010014358.30cb74b5@debxo>
References: <20101010014358.30cb74b5@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, that should've been 1/5, not 1/7.  Two additional x86 patches
snuck in there that are already in Grant's test-devicetree branch.


On Sun, 10 Oct 2010 01:43:58
-0700 Andres Salomon <dilinger@queued.net> wrote:

> 
> Clean up pdt.c:
>  - make build dependent upon config OF_PROMTREE
>  - #ifdef out the sparc-specific stuff
>  - create pdt-specific header
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

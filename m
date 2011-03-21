Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1CUJhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 05:37:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53801 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1CUJhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 05:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=P0jWOoAF+L2ctAhjkueTpvNVboSl4w4KoIzCrq/r+g6fVFBQtoXqsLqHdbj3vMdws2
         165R82aknZWFKBLlOCuwDynwvFFqLEwqhENHXswcMap0nZ+hjsU4G9+IhbjQW5gSThSe
         zRIJKHLIKKbwXcCjmMBtW4j6RHS6TdJy/EzWQ=
Date: Mon, 21 Mar 2011 02:37:35 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lauri Leukkunen <lauri.leukkunen@nokia.com>,
        Aaro Koskinen <aaro.koskinen@nokia.com>,
        Srikar <ext-srikar.1.bhavanarayana@nokia.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] input: TOUCHSCREEN_TSC2005 should depend on
 GENERIC_HARDIRQS
Message-ID: <20110321093735.GB6897@core.coreip.homeip.net>
References: <alpine.DEB.2.00.1103201312320.6633@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1103201312320.6633@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 20, 2011 at 01:23:16PM +0100, Geert Uytterhoeven wrote:
> drivers/input/touchscreen/tsc2005.c: In function ‘tsc2005_probe’:
> drivers/input/touchscreen/tsc2005.c:666: error: implicit declaration of function ‘set_irq_wake’
> 
> In addition, migrate from set_irq_wake() (marked "do not use" as of commit
> a0cd9ca2b907d7ee26575e7b63ac92dad768a75e ("genirq: Namespace cleanup")) to
> irq_set_irq_wake().
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied, thank you Geert.

-- 
Dmitry

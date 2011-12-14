Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab1LNEq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 23:46:28 -0500
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:59671
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755756Ab1LNEqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 23:46:24 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Dec 2011 23:46:24 EST
Date: Tue, 13 Dec 2011 23:39:39 -0500
From: Sean MacLennan <seanm@seanm.ca>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 12 (staging/rtl8192e)
Message-ID: <20111213233939.572235ff@opus.seanm.ca>
In-Reply-To: <4EE63A9C.1090503@xenotime.net>
References: <20111212161444.22a11535656c6bfbd884d9ec@canb.auug.org.au>
	<4EE63A9C.1090503@xenotime.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 09:32:12 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 12/11/2011 09:14 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111209:
> 
> 
> ERROR:
> "rtllib_crypt_delayed_deinit" [drivers/staging/rtl8192e/rtllib.ko]
> undefined! ERROR:
> "rtllib_get_crypto_ops" [drivers/staging/rtl8192e/rtllib.ko]
> undefined! ERROR:
> "rtllib_crypt_deinit_entries" [drivers/staging/rtl8192e/rtllib.ko]
> undefined! ERROR:
> "rtllib_crypt_deinit_handler" [drivers/staging/rtl8192e/rtllib.ko]
> undefined!
> 
> Full randconfig file is attached.
> 

This is my fault and I am working on a patch for this. I can submit a
quick fix if needed.

Cheers,
   Sean

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2DBU1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:27:15 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:57424 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763Ab2DBU1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:27:14 -0400
Date: Mon, 2 Apr 2012 21:27:10 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120402202709.GA5970@milliways>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways>
 <20120401161108.GA6448@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120401161108.GA6448@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=wom5GMh1gUkA:10 a=2EL98pTPio4A:10 a=uObrxnre4hsA:10 a=8nJEP1OIZ-IA:10 a=BV8SaKpQwGLlrb_eD1EA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 05:11:08PM +0100, Ken Moffat wrote:
> On Sat, Mar 31, 2012 at 04:23:56AM +0100, Ken Moffat wrote:
> 
> [ update : 3.4.0-rc1 boots without reverting this ]

 Both 3.3.1 and 3.2.14 boot.  Thanks to whoever fixed this!

ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce

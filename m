Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab0CTKiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 06:38:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab0CTKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 06:38:16 -0400
Date: Sat, 20 Mar 2010 03:37:56 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Ian Campbell <ijc@hellion.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>, jeremy@goop.org
Subject: Re: 2.6.34-rc2: xen DomU not booting
In-Reply-To: <1269077602.28761.42.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.01.1003200335110.5493@bogon.housecafe.de>
References: <alpine.DEB.2.01.1003200058030.5493@bogon.housecafe.de> <1269077602.28761.42.camel@localhost.localdomain>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+WMzQl02QVPSmSONnbdXFguHGclL22l6BUgYH
 /bE0Cdlqnz9Pz7kWmsvm6jPAng2O7+foRl+Pum4XQT1Rmf3108
 525LZyruOIJDRpkA/jTBw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010 at 09:33, Ian Campbell wrote:
> Can you try this patch please, I think it will resolve the issue you
> see.
> https://patchwork.kernel.org/patch/87081/

Wow, thanks for the swift response! And yes, it does indeed resolve the 
issue, the domU is now booting again.

For the record, I've put the .config and dmesg on:
http://nerdbynature.de/bits/2.6.34-rc2/xen/

Thanks again!
Christian.
-- 
BOFH excuse #239:

CPU needs bearings repacked

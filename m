Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1CVDeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:34:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34904 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab1CVDdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:33:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=b+fiGkgOgbGasGGqceYfCJPQNwwEohsNykkAW/RhRbB3qcFMXJBtUv6lutPr5xY5UD
         +OP10z1+vp5bAHEPD5oeU74vN6Ex+r8shjuCy0vMjx/ie6NSMzWHG9snmzWJojrOGFIx
         OzMQ5Dgt2ccviMMcSM9LV7KlpiEjDfxafMyjY=
Date: Tue, 22 Mar 2011 11:33:14 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, akpm@linux-foundation.org, rdunlap@xenotime.net,
        joe@perches.com
Subject: [RFC]A question about kernel's development
Message-ID: <20110322033312.GA2219@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, greg@kroah.com,
	akpm@linux-foundation.org, rdunlap@xenotime.net, joe@perches.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
   I wanna know our kernel's development 
procedure for details. I just realize
when we get a stable release, we must 
merge trementous patches into kernel.
I often watch -rc kernels, -git kernels, 
, -mm kernels and know their promulgators.
But i don't know their relationships and
sequences for shaping stable ones.
   Okay, now we want to develop 2.6.38 
to 2.6.39. How many specific steps should we
do? In fact, i recognize some. But i want to 
understand all the concrete procedures. Could
anyone help me, thanks in advance.

Thanks.
Best Regards.
Harry Wei.

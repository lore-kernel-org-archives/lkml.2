Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab2DDHuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:50:40 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:43282 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2DDHuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:50:39 -0400
Date: Wed, 4 Apr 2012 10:50:36 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Dave Airlie <airlied@gmail.com>
cc: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: nouveau regression in 3.4-rc4-144
In-Reply-To: <CAPM=9tx4jJLRzfBjePYWLQh5Ff6t6DGu3fSMxv7eENneokDsrQ@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1204041050200.26551@math.ut.ee>
References: <alpine.SOC.1.00.1204041000040.26551@math.ut.ee> <CAPM=9twGWHgQU01mj0=Y2iOe1Oo2za4QLY-DkEyYCRVd60+iTg@mail.gmail.com> <CAPM=9tx4jJLRzfBjePYWLQh5Ff6t6DGu3fSMxv7eENneokDsrQ@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please try reverting d06221c0617ab6d0bc41c4980cefdd9c8cc9a1c1
> 
> If this works, can someone get it fixed or reverted, I'm off on
> holidays, limited net.

Yes, this fixes it.

-- 
Meelis Roos (mroos@linux.ee)

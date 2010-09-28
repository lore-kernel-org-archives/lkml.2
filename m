Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0I1VvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:51:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54684 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab0I1VvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:51:22 -0400
Date: Tue, 28 Sep 2010 22:51:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, bharrosh@panasas.com, julia@diku.dk,
        akpm@linux-foundation.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
Message-ID: <20100928215108.GH19804@ZenIV.linux.org.uk>
References: <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
 <20100928211106.GE19804@ZenIV.linux.org.uk>
 <20100928212417.GF19804@ZenIV.linux.org.uk>
 <20100928.144215.246551852.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100928.144215.246551852.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 02:42:15PM -0700, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Tue, 28 Sep 2010 22:24:17 +0100
> 
> > Who maintains these drivers?
> 
> Your guess is as good as mine, which probably means there is no
> active maintainer right now.

Oh, joy...  I'm regulary using uml, with some of these drivers used
from time to time, but I've no fscking clue on e.g. VDE - even on
the "what the hell it is" level ;-/

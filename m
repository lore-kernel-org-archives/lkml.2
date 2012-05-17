Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030617Ab2EQWu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:50:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39341 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030492Ab2EQWu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:50:26 -0400
Message-ID: <1337295024.8872.33.camel@joe2Laptop>
Subject: Re: [RFC PATCH net-next] hp100: delete VG/AnyLAN hp100
From: Joe Perches <joe@perches.com>
To: Francois Romieu <romieu@fr.zoreil.com>, Joel Soete <soete.joel@scarlet.be>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joel Soete <soete.joel@scarlet.be>
Date: Thu, 17 May 2012 15:50:24 -0700
In-Reply-To: <20120517222843.GA30680@electric-eye.fr.zoreil.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
	 <1337272841-25931-3-git-send-email-paul.gortmaker@windriver.com>
	 <4FB52C99.6010303@windriver.com> <20120517212039.GC27789@windriver.com>
	 <1337292547.8872.20.camel@joe2Laptop>
	 <20120517222843.GA30680@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 00:28 +0200, Francois Romieu wrote:
> Joe Perches <joe@perches.com> :
> > On Thu, 2012-05-17 at 17:20 -0400, Paul Gortmaker wrote:
> > > [Re: [PATCH 2/5] drivers/net: delete all code/drivers depending on CONFIG_MCA
> > 
> > If we're removing really old and unused stuff,
> > how about the VG/AnyLAN driver too?
> 
> Joel Soete appeared to actively use a PCI one with recent kernels back
> in 2007.

I saw people using TR adapters with Linux as of 2008/9.

That doesn't mean it's common or make it desirable to
keep TR in the current kernel tree though.

Is VG/AnyLAN different?


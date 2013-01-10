Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3AJMQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:16:09 -0500
Received: from mail.us.es ([193.147.175.20]:48377 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab3AJMQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:16:06 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.6/16457. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-99.2/7.5):. 
 Processed in 1.644059 secs); 10 Jan 2013 12:16:04 -0000
X-Envelope-From: pneira@us.es
Date: Thu, 10 Jan 2013 13:16:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Borislav Petkov <bp@alien8.de>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: v3.8-rc3: uninitialized warnings in net/netfilter/xt_CT.c
Message-ID: <20130110121602.GA20429@1984>
References: <20130110111821.GA23008@liondog.tnic>
 <20130110114742.GA17883@1984>
 <20130110120121.GD23008@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130110120121.GD23008@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 01:01:21PM +0100, Borislav Petkov wrote:
> On Thu, Jan 10, 2013 at 12:47:42PM +0100, Pablo Neira Ayuso wrote:
> > Patch attached to address this issue.
> 
> > From 3ceaa3b1baa660aaeef63b86ea9771dcab6d0acd Mon Sep 17 00:00:00 2001
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date: Thu, 10 Jan 2013 12:42:15 +0100
> > Subject: [PATCH] netfilter: xt_CT: fix unset return value if conntrack zone
> >  are disabled
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > 
> > net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v1’:
> > net/netfilter/xt_CT.c:250:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> > net/netfilter/xt_CT.c: In function ‘xt_ct_tg_check_v0’:
> > net/netfilter/xt_CT.c:112:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> > 
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Yep, that's exactly what I meant, thanks Pablo.
> 
> Acked-by: Borislav Petkov <bp@alien8.de>

Applied, thanks Borislav.

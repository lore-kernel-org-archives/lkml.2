Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2CDLMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 06:12:18 -0500
Received: from mail.us.es ([193.147.175.20]:47518 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab2CDLMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 06:12:15 -0500
Date: Sun, 4 Mar 2012 12:12:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        jengelh@medozas.de, rostedt@goodmis.org
Subject: Re: [PATCH 1/4] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
Message-ID: <20120304111211.GA22592@1984>
References: <1328400892-22409-1-git-send-email-richard@nod.at>
 <1328400892-22409-3-git-send-email-richard@nod.at>
 <20120301112732.GA6806@1984>
 <4F4FEC83.6090504@nod.at>
 <20120302164945.GA13723@1984>
 <4F50FAE2.4080903@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F50FAE2.4080903@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 05:52:50PM +0100, Richard Weinberger wrote:
> Am 02.03.2012 17:49, schrieb Pablo Neira Ayuso:
> > On Thu, Mar 01, 2012 at 10:39:15PM +0100, Richard Weinberger wrote:
> >> Am 01.03.2012 12:27, schrieb Pablo Neira Ayuso:
> >>> While merging ipt_LOG and ip6t_LOG, you introduced some bug that
> >>> corrupts the log line. Note the extra PROTO=, I don't have any UDPLITE
> >>> traffic here.
> >>>
> >>> Looks like a missing break in one switch.
> >>
> >> I got confused by my own logic. :-\
> >> Does the attached patch fix the issue?
> >> It's based on "Netfilter: xt_LOG: Add timestamp support"
> > 
> > This patch lacks of description. If you don't make it myself, I have
> > to do it for you :-(
> > 
> > Please, send me patches following the standard format next time.
> 
> It was a "does this patch solve the problem"-Patch.
> Does it fix the problem?
> 
> If so, I'll send an official one...

Sorry, that's too much overhead. I don't mind testing it, but I want
to apply it as soon as it fixes the problem ;-)

It seems to fix the problem. I have added the description and will
push to my git tree. Thanks.

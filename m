Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0FGJk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:40:57 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32331 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751424Ab0FGJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:40:55 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: JH9npwMVM1nua8kbKyIhx_GjQknT0ksgjBSAgAaXG4S1PpkPNZP4MABoBXt6x2k8ifTwU.kkBVcj8.Ub8ToKYcFlWsdf3uXJKQrf8i.YIMq26Ep64siUB.WW72YdAPWiuvNpjbHD9p30t1HBivZ8KPNA.eViK1_dR3CuCU.yablHkXNviHDJOYhFO.5ZBmCm135nGBTVxme_.IjtxGw20sJJjxY4vVQaTyN23P.6TSqrJhwP00Umq.I4HglTEMX403Zdr1ekmBrBEGnyzWViLK4uwDa6PkGO6ySqk4DL3zkWKMsiweWzdPU9mBBXDpPfSSrC9X3OoQXG8Nrnp1uT1zcR
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu,
       bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com
In-Reply-To: <20100607183438Y.fujita.tomonori@lab.ntt.co.jp>
References: <1275899236.26888.40.camel@haakon2.linux-iscsi.org>
	 <20100607175535Q.fujita.tomonori@lab.ntt.co.jp>
	 <1275901629.26888.62.camel@haakon2.linux-iscsi.org>
	 <20100607183438Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Mon, 07 Jun 2010 02:40:52 -0700
Message-Id: <1275903652.26888.73.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 18:35 +0900, FUJITA Tomonori wrote:
> On Mon, 07 Jun 2010 02:07:09 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Mon, 2010-06-07 at 17:56 +0900, FUJITA Tomonori wrote:
> > > On Mon, 07 Jun 2010 01:27:16 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > Ok, I just fixed some minor breakage and applied patch 3 on top of
> > > > tgt.git/pass in my local tree and everything appears to work with
> > > > '-E bsg -Y pt'.
> > > > 
> > > > Please let me know if you have any other comments on the BSG bits or if
> > > > you would like me to send along a updated patch 3 seperately.
> > > 
> > > Please send patches except for bsg first.
> > > 
> > > About bsg support, we need both sg and bsg? Just bsg is not enough?
> > 
> > I figured you would still like legacy support w/o bsg for the forseeable
> > future with older production kernels.  I don't recall which kernel BSG
> > support was added or if this code has already been backported to the
> > various distro kernels.
> 
> I prefer to support only bsg (until someone tells me to support sg).
> 

Ok, if that is the case I will respin a patch on top of tgt.git/pass to
remove SG and use BSG exclusively.  Please let me know if you have any
more recommendations in this area.

> 
> btw, if you look for a tool to generate a bidi command, my sgv4-tools
> might work for you.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git
> 
> try sgv4_xdwriteread (note that it's not useful at all except for
> generating bidi).

Ah perfect, this is exactly what I am looking for.  Many thanks.

Best,

--nab


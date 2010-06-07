Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666Ab0FGJHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:07:13 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:31998 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756686Ab0FGJHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:07:11 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: EVj9NFoVM1kRkc3JTan5Q2a_YWQbisWcn7vZNCC2.24_Hg1Ly2r4txttWHau40d5F3rz4FiqHOL.AEee0ClwIu3XtYXCR.Ch9XWxgtrSAQ8o5szbq8uUuP7L5KNTUPUmRIAsL_Al0g254wrTGjWyydHvQ1k62B_tj230cH71sRo8PPi0yI8oAXZ4iP9mw7j3odO0n_0JpH10I7I8S6Sh8uAPy8Eql.yAx7E3IyZ84MNBgsSejiiwIB4yO.u.EGucgoKOHvNY1V85_f0JMwM.VJApFYlXN2b1OqGl.k9VFq1bXhgoEchXiS6hLdaaLYpOkl8u9ogfsiM31UxTdJ_yjahmx1r9Dof1BE2pKCr0qMKPEg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 0/3] Add proper STGT <-> bs_sg passthrough v3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: stgt@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu,
       bharrosh@panasas.com, James.Bottomley@suse.de, dgilbert@interlog.com
In-Reply-To: <20100607175535Q.fujita.tomonori@lab.ntt.co.jp>
References: <1275882615-5354-1-git-send-email-nab@linux-iscsi.org>
	 <20100607154432Y.fujita.tomonori@lab.ntt.co.jp>
	 <1275899236.26888.40.camel@haakon2.linux-iscsi.org>
	 <20100607175535Q.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Mon, 07 Jun 2010 02:07:09 -0700
Message-Id: <1275901629.26888.62.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 17:56 +0900, FUJITA Tomonori wrote:
> On Mon, 07 Jun 2010 01:27:16 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > Ok, I just fixed some minor breakage and applied patch 3 on top of
> > tgt.git/pass in my local tree and everything appears to work with
> > '-E bsg -Y pt'.
> > 
> > Please let me know if you have any other comments on the BSG bits or if
> > you would like me to send along a updated patch 3 seperately.
> 
> Please send patches except for bsg first.
> 
> About bsg support, we need both sg and bsg? Just bsg is not enough?

I figured you would still like legacy support w/o bsg for the forseeable
future with older production kernels.  I don't recall which kernel BSG
support was added or if this code has already been backported to the
various distro kernels.

Best,

--nab



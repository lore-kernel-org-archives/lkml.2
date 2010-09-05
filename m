Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0IFAD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:03:57 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:22210 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754270Ab0IFADz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:03:55 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: sKUFWDIVM1nCbCe2L5Szqrl9WCCZI6MApovpecPdw_WGE2j
 yX.2UBDA3Q50aDOpkn4e1DZu9qZGiHH6XSzcXF.YSBydTIbgL20IsRl7fw8j
 UvKfiGhSCnjJQlFUO2KPG4TheaqYQ.vRSrl_H.T1tPEu8HNhdtljYDOv_etY
 Gqqleu0Jxp_jH3hgvasOtu6fIl8UXrujtICfV.EdCaaje0eE464TOjr4MIRZ
 WCBJuou71LTIBMTikfNAHuAvx5PypR6RaFsykD8rjDUaHGH.vN_SwS5m51RO
 5AZrowXhmrs2GqmlaO_bxo_Y-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        James Bottomley <James.Bottomley@suse.de>,
        Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org,
        Chetan Loke <chetanloke@gmail.com>,
        Chetan Loke <generationgnu@yahoo.com>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100905234134.GA17212@core.coreip.homeip.net>
References: <4C76CA57.3050405@vlnb.net>
	 <1282857806.32007.175.camel@haakon2.linux-iscsi.org>
	 <4C79484B.3090607@vlnb.net>
	 <1283028468.32007.357.camel@haakon2.linux-iscsi.org>
	 <4C7C18CE.5020103@vlnb.net>
	 <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	 <4C7FFD1A.8090509@vlnb.net>
	 <1283459158.5598.143.camel@haakon2.linux-iscsi.org>
	 <20100905201802.GC18411@core.coreip.homeip.net>
	 <1283723447.556.133.camel@haakon2.linux-iscsi.org>
	 <20100905234134.GA17212@core.coreip.homeip.net>
Content-Type: text/plain
Date: Sun, 05 Sep 2010 16:59:54 -0700
Message-Id: <1283731194.556.147.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-05 at 16:41 -0700, Dmitry Torokhov wrote:
> On Sun, Sep 05, 2010 at 02:50:47PM -0700, Nicholas A. Bellinger wrote:
> > Anyways, if we are going to compare SCM distributed vs. centralized
> > workflow in terms of kernel projects, lets please at least compare
> > apples to apples here.
> > 
> 
> No, we should not be comparing SCMs at all here but rather 2 competing
> implementations based on quality of the code. You tried to bring SMC
> angle in and I am saying that it is BS.
> 

Again, without getting into another pointless flamewar,  I think the
main point here is that a open source project using a distributed
workflow (like git) has major advantages when it comes to working with a
larger group of developers than a centralized model (like SVN) does.

Because being a subsystem maintainer typically involves this type of
complex workflow involving lots of different parties, git is a tool that
was created (originally) expressely for a kernel workflow, and for those
types of people it works really, really well.

So, please understand that code and project workflow is only one of the
reasons why TCM/LIO v4 was selected over SCST.   I invite you to take a
closer look at the RFC Code that has been posted last week if you want
to get into the nitty-gritty techinical details, which this thread has
thus far been avoiding.

Best,

--nab


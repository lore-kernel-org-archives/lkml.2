Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0HTLBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 07:01:10 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:25378 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752688Ab0HTLBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:01:08 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ALKeZx0VM1lMlbHNcNs7XdEt8nnMZdck7uA64dkCLjeDb.t
 naRbAVQOTRIF7ZA6n3V20pkR7Fyn8VC3mItzTy485pxIfnR4C_toqRuu1h6_
 hbbb6y55HyWxHorK2WwcrwZlFbD6Fk.NBxlmP3I9IU8ITmUeY2ZNAuAHbpX1
 8yLu7sXXRtfj2cft3AqF3FkrYKNCAJjf2ifG8v3OTov6SjUJrhVoE1fMapGp
 wSq8ExO12OZZqObkhPi5FIURsx8fmhoAcCvRl6hV4e3mh2uSlHg3t6mBphiW
 rYoFs5bxm8DFBzhE9WYg4kmDbT_mu7JHGZzyEnyyVpP525lzoCC5k9Ixqw0_
 DmPVQsHbhGidXO3LCcQ--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de,
        hare@suse.de
In-Reply-To: <20100820194231R.fujita.tomonori@lab.ntt.co.jp>
References: <1282295674.30453.337.camel@haakon2.linux-iscsi.org>
	 <20100820184031L.fujita.tomonori@lab.ntt.co.jp>
	 <1282298560.30453.370.camel@haakon2.linux-iscsi.org>
	 <20100820194231R.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 03:57:26 -0700
Message-Id: <1282301846.30453.383.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 19:43 +0900, FUJITA Tomonori wrote:
> On Fri, 20 Aug 2010 03:02:40 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > review of TCM core and TCM_Loop.   But perhaps at this point LIO-Target
> > should go in together with TCM Core and TCM_Loop once mnc can review the
> > software iSCSI target pieces..?
> 
> I think that James meant that we have only one scsi target
> implementation and we need to replace the current in-kernel target
> mode driver. So I don't think that we can merge TCM core without its
> ibm vscsi driver. I might be wrong though.

Ah yes the ibm vscsi driver.   Well for that part I suppose we will need
a seperate tcm_ibmvscsi fabric module moving forward.  This is where
that python script I mentioned when tcm_lpfc, tcm_qla2xxx, tcm_mvsas
where originally posted that would generates a new functioning configfs
skeleton with NOP I/O path handlers from a handful of user input.

Anyways, something like this would really come in handy for making ibm
vscsi go, and plus it makes life easier for me too.  I will try to get a
script along this lines coded up in the next week(s) so that we can
finally have a pain-free method of generation for new v4 kernel target
mode modules for new developers.

There will be no limit per customer.  ;)

--nab


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0JUTpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:45:06 -0400
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:24192 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751880Ab0JUTpD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:45:03 -0400
X-Greylist: delayed 1110 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Oct 2010 15:45:03 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=tsizKuQ9fgdGif7WcwmnGvFQby6no6sjfe7pQpv6Bjq4a91F29R28dynt4khDDYU5lrqCRddK86znWQIrcBGOt4HizK1EBSR/MXnnhA69ZCkAa1l4E3xDRy9HMUrIcXzLdKC5Uwn2QIPj7RGEZ1eGVt8mf9apmaecuvENt+mbsc=;
Message-ID: <743248.2576.qm@web31812.mail.mud.yahoo.com>
X-YMail-OSG: 5MQj1uMVM1ldk5_PwrrxSM2AMHuu0tbva95CVXFWflp9poP
 2G3335wvGWkjoCuALUYycRGO0B.J3SauoYF2jjLkgnJ98KnOr3im2SY.UEIb
 nzEfkpL1yhGytxoNJQe1ZSbunB15nvN7RCgHq_2Ug7TT3QgJSAqgWPzrtA_U
 6AMhAYcXXbs9Y5Osy3PSJHvTCMO6YjAl10iIc24ve0zSs0iAjKxZ9ys1sYiZ
 v6JQHekOBslRCW_fQDzsq7MhBZDcQzRigwgypmj8tlOTUaq_jRL0UZqil3FL
 zRDkOQFixS4i_jaeCW4vd1krSn7DtAaC7JkCuxz5Zn5Mhhteo.jnKYW0-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 21 Oct 2010 12:26:31 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Mike Anderson <andmike@linux.vnet.ibm.com>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1287607774.10283.78.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 10/20/10, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:

> From: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Subject: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
> To: "linux-kernel" <linux-kernel@vger.kernel.org>, "linux-scsi" <linux-scsi@vger.kernel.org>
> Cc: "Vasu Dev" <vasu.dev@linux.intel.com>, "Tim Chen" <tim.c.chen@linux.intel.com>, "Andi Kleen" <ak@linux.intel.com>, "Matthew Wilcox" <willy@linux.intel.com>, "James Bottomley" <James.Bottomley@suse.de>, "Mike Christie" <michaelc@cs.wisc.edu>, "Jens Axboe" <jaxboe@fusionio.com>, "James Smart" <james.smart@emulex.com>, "Andrew Vasquez" <andrew.vasquez@qlogic.com>, "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, "Hannes Reinecke" <hare@suse.de>, "Joe Eykholt" <jeykholt@cisco.com>, "Christoph Hellwig" <hch@lst.de>, "Jon Hawley" <warthog9@kernel.org>, "MPTFusionLinux" <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, "Luben Tuikov" <ltuikov@yahoo.com>, "mvsas maintainer" <kewei@marvell.com>, "pm8001 maintainer Jack Wang" <jack_wang@usish.com>, "Brian King" <brking@linux.vnet.ibm.com>, "Mike Anderson" <andmike@linux.vnet.ibm.com>, "Christof Schmitt" <christof.schmitt@de.ibm.com>, "Tejun Heo" <tj@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>
> Date: Wednesday, October 20, 2010, 1:49 PM
> Greetings all,
> 
> So as we get closer to the .37 merge window, I wanted to
> take this
> oppourtunity to recap the current status of the
> drop-host_lock /
> unlocked_qcmds=1 patches, and what is required for the next
> RFCv5 and
> hopefully a merge into .37.  The last RFCv4 was posted
> here:
> 
> http://marc.info/?l=linux-kernel&m=128563953114561&w=2
> 
> Since then, Christof Schmitt has sent a patch to drop
> struct
> scsi_cmnd->serial_number usage in zfcp, and Tim Chen has
> sent an
> important fix to drop an extra host_lock access that I
> originally missed
> in qla2xxx SHT->queuecommand() that certainly would have
> deadlocked a
> running machine.   Many thanks to Christof
> and Tim for your
> contributions and review!
> 
> So at this point in the game the current score sits at:
> 
> *) core drivers/scsi remaining issue(s):
> 
> The issue raised by andmike during RFCv4 described as:
> 
> "If we skip __scsi_try_to_abort_cmd when REQ_ATOM_COMPLETE
> is set it
> would be correct for the scsi_decide_disposition cases but
> it would
> appear this would stop __scsi_try_to_abort_cmd from being
> called in the
> time out case as REQ_ATOM_COMPLETE is set prior to calling
> blk_rq_timed_out."
> 
> The complete discussion is here:
> 
> http://marc.info/?l=linux-scsi&m=128535319915212&w=2
> 
> We still need folks with experience to dig into this code,
> so you know
> the scsi_error.c code please jump in!
> 
> *) LLD libraries running by default w/ unlocked_qcmds=1
> 
> libiscsi: need ack from mnc
> libsas: need ack from jejb
> libfc: remaining rport state + host_lock less issue. 
> Need more input
>        from mnc for James Smart
> and Joe on this...
> libata: jgarzik thinks this should be OK, review and ack
> from tejun
>         would also be very helpful.
> 
> The main issue remaining here is the audit of libfc rport
> (and other..?)
> code that assumes host_lock is held to protect state. 
> mnc, do you have
> any more thoughts for James Smart and Joe here..?
> 
> *) Individual LLDs running by default w/ unlocked_qcmds=1
> 
> aic94xx: need ack maintainer at adaptec..?)

Adaptec doesn't exist anymore--it's just a memory in the minds of
many good engineers.  Anyway, as a former Adaptec employee and
the author of aic94xx and the SAS code in the Linux kernel (which
Bottomley copied from a git tree from an Adaptec server or maybe
from the linux-scsi ML, munged it up and submitted as his own
into linux-scsi git tree) I can give an ACK on both. Both the
aic94xx and the SAS code were written with the host lock as a
kludge and we unlock/lock it as you can see in the code.

> mvsas: need ack maintainer at marvell..?)
> pm8001: need ack Jang Wang
> qla4xxx, qla2xxx: need ack Andrew Vasquez
> fnic:  need ack Joe Eykholt
> 
> Aside from the required ACKs, I am not aware of any other
> mainline LLDs
> doing the legacy SHT->queuecommand() -> unlock()
> -> do_lld_work() ->
> lock() that have not already been converted.
> 
> The main question here is if any out of tree SCSI LLDs use
> this legacy
> optimization..  Should we come up with a compile time
> way to alert
> vendors to this..?
> 
> *) Individual LLDs converted to use explict
> scsi_cmd_get_serial()
> 
> mpt2sas: Add scsi_cmd_get_serial() call
> mpt/fusion: Add scsi_cmd_get_serial() call
> dpt_i2o: Add scsi_cmd_get_serial() call
> eata: Add scsi_cmd_get_serial() call
> u14-34f: Add scsi_cmd_get_serial() call
> zfcp: Remove scsi_cmnd->serial_number from debug traces
> 
> Aside from the required ACKs, I am not aware of any other
> mainline LLDs
> that use struct scsi_cmnd->serial_number internally that
> have not
> already been converted.  The same applies to out of
> tree modules for
> this, but is certainly not critical.
> 
> So as the clock winds down to get this merged into .37, if
> anyone else
> has any concerns or comments please let myself and the
> other relivent
> maintainers know and we will try to address them
> accordingly.
> 
> Thanks!
> 
> --nab
> 
> 

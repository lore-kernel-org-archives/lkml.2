Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab1CWU15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:27:57 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56049 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab1CWU14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:27:56 -0400
Subject: Re: [PATCH-v2] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric
	module
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <1300903542.15899.27.camel@mulgrave.site>
References: <1300487957-28800-1-git-send-email-nab@linux-iscsi.org>
	 <1300903542.15899.27.camel@mulgrave.site>
Content-Type: text/plain
Date: Wed, 23 Mar 2011 13:20:29 -0700
Message-Id: <1300911629.18039.11.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 13:05 -0500, James Bottomley wrote:
> On Fri, 2011-03-18 at 15:39 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds the TCM_Loop Linux/SCSI LLD fabric module for
> > accessing TCM device
> > backstores as locally accessable SCSI LUNs in virtual SAS, FC, and
> > iSCSI Target ports
> > using the generic fabric TransportID and Target Port WWN naming
> > handlers from TCM's
> > target_core_fabric_lib.c  The TCM_Loop module uses the generic fabric
> > configfs infratructure
> > provided by target_core_fabric_configfs.c and adds a module dependent
> > attribute for the
> > creation/release of the virtual I_T Nexus connected the TCM_Loop
> > Target and Initiator Ports.
> > 
> > TCM_Loop can also be used with scsi-generic and BSG drivers so that
> > STGT userspace
> > fabric modules, QEMU-KVM and other hypervisor SCSI passthrough support
> > can
> > access TCM device backstore and control CDB emulation.
> > 
> > For more information please see:
> > 
> > http://linux-iscsi.org/wiki/Tcm_loop
> > 
> > This patch has been updated with changes from Christoph's feedback.
> 
> And checkpatch next time, too please:
> 
> total: 25 errors, 25 warnings, 1681 lines checked
> 

Thanks for fixing this up James.  I will get your checkpatch cleanups
merged from scsi-misc-2.6.git -> lio-core-2.6.git shortly.

--nab


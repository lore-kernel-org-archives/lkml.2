Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1GSXNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:13:17 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:50367 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1GSXNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:13:16 -0400
Subject: Re: [PATCH 00/16] Replace Scsi_Cmnd
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        JBottomley@parallels.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1310710771.3184.51.camel@offbook>
References: <1310710771.3184.51.camel@offbook>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Tue, 19 Jul 2011 19:12:33 -0400
Message-ID: <1311117153.3215.2.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Can I get some input on this?

Thanks,
Davidlohr

On Fri, 2011-07-15 at 02:19 -0400, Davidlohr Bueso wrote:
> Hi,
> 
> Plenty of older drivers are still using the ugly Scsi_Cmd typedef. The
> following patchset removes it and change it for struct scsi_cmnd.
> 
> drivers/scsi/NCR5380.c       |   72 +++++++++++++++++-----------------
> drivers/scsi/NCR5380.h       |   14 +++---
> drivers/scsi/NCR53c406a.c    |    6 +-
> drivers/scsi/aha152x.c       |   68 ++++++++++++++++----------------
> drivers/scsi/aha1542.c       |   28 ++++++------
> drivers/scsi/aha1542.h       |   10 ++--
> drivers/scsi/aha1740.c       |    8 ++--
> drivers/scsi/aha1740.h       |    4 +-
> drivers/scsi/atari_NCR5380.c |   90
> +++++++++++++++++++++---------------------
> drivers/scsi/atari_scsi.c    |   10 ++--
> drivers/scsi/atari_scsi.h    |    2 +-
> drivers/scsi/dtc.h           |    4 +-
> drivers/scsi/fd_mcs.c        |   10 ++--
> drivers/scsi/g_NCR5380.c     |   10 ++--
> drivers/scsi/g_NCR5380.h     |    4 +-
> drivers/scsi/gdth.c          |   64 +++++++++++++++---------------
> drivers/scsi/gdth.h          |   10 ++--
> drivers/scsi/gdth_proc.c     |    2 +-
> drivers/scsi/ibmmca.c        |   26 ++++++------
> drivers/scsi/in2000.c        |   68 ++++++++++++++++----------------
> drivers/scsi/in2000.h        |   12 +++---
> drivers/scsi/megaraid.c      |   28 ++++++------
> drivers/scsi/megaraid.h      |   16 ++++----
> drivers/scsi/nsp32_debug.c   |    2 +-
> drivers/scsi/pas16.h         |    4 +-
> drivers/scsi/scsi.h          |    3 -
> drivers/scsi/scsi_typedefs.h |    2 -
> drivers/scsi/sym53c416.c     |    6 +-
> drivers/scsi/sym53c416.h     |    2 +-
> drivers/scsi/wd7000.c        |    2 +-
> 30 files changed, 291 insertions(+), 296 deletions(-) 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



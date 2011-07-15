Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929Ab1GOGTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:19:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54779 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab1GOGTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:19:48 -0400
Subject: [PATCH 00/16] Replace Scsi_Cmnd
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave@gnu.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 15 Jul 2011 02:19:31 -0400
Message-ID: <1310710771.3184.51.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Plenty of older drivers are still using the ugly Scsi_Cmd typedef. The
following patchset removes it and change it for struct scsi_cmnd.

drivers/scsi/NCR5380.c       |   72 +++++++++++++++++-----------------
drivers/scsi/NCR5380.h       |   14 +++---
drivers/scsi/NCR53c406a.c    |    6 +-
drivers/scsi/aha152x.c       |   68 ++++++++++++++++----------------
drivers/scsi/aha1542.c       |   28 ++++++------
drivers/scsi/aha1542.h       |   10 ++--
drivers/scsi/aha1740.c       |    8 ++--
drivers/scsi/aha1740.h       |    4 +-
drivers/scsi/atari_NCR5380.c |   90
+++++++++++++++++++++---------------------
drivers/scsi/atari_scsi.c    |   10 ++--
drivers/scsi/atari_scsi.h    |    2 +-
drivers/scsi/dtc.h           |    4 +-
drivers/scsi/fd_mcs.c        |   10 ++--
drivers/scsi/g_NCR5380.c     |   10 ++--
drivers/scsi/g_NCR5380.h     |    4 +-
drivers/scsi/gdth.c          |   64 +++++++++++++++---------------
drivers/scsi/gdth.h          |   10 ++--
drivers/scsi/gdth_proc.c     |    2 +-
drivers/scsi/ibmmca.c        |   26 ++++++------
drivers/scsi/in2000.c        |   68 ++++++++++++++++----------------
drivers/scsi/in2000.h        |   12 +++---
drivers/scsi/megaraid.c      |   28 ++++++------
drivers/scsi/megaraid.h      |   16 ++++----
drivers/scsi/nsp32_debug.c   |    2 +-
drivers/scsi/pas16.h         |    4 +-
drivers/scsi/scsi.h          |    3 -
drivers/scsi/scsi_typedefs.h |    2 -
drivers/scsi/sym53c416.c     |    6 +-
drivers/scsi/sym53c416.h     |    2 +-
drivers/scsi/wd7000.c        |    2 +-
30 files changed, 291 insertions(+), 296 deletions(-) 



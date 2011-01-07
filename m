Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1AGUuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:50:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176Ab1AGUuD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:50:03 -0500
MIME-Version: 1.0
In-Reply-To: <1294345782.22825.341.camel@mulgrave.site>
References: <1294345782.22825.341.camel@mulgrave.site>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 7 Jan 2011 12:49:40 -0800
Message-ID: <AANLkTi=GhdvQUgZh56XRx95+ZwiqaiJTw8ti-403Gse2@mail.gmail.com>
Subject: Re: [GIT PULL] first set of SCSI patches for the 2.6.38 merge window
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 12:29 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> ..
>  include/scsi/libsas.h                       |    2
>  include/scsi/scsi.h                         |   28
>  162 files changed, 16069 insertions(+), 12242 deletions(-)

You're missing a -M and a --summary. That should look like this:

  ...
  include/scsi/libsas.h                              |    2 +
  include/scsi/scsi.h                                |   28 +
  161 files changed, 11139 insertions(+), 7312 deletions(-)
  delete mode 100644 drivers/scsi/bfa/bfa_cb_ioim.h
  delete mode 100644 drivers/scsi/bfa/bfa_drv.c
  delete mode 100644 drivers/scsi/bfa/bfa_os_inc.h
  rename drivers/scsi/megaraid/{megaraid_sas.c => megaraid_sas_base.c} (90%)
  create mode 100644 drivers/scsi/megaraid/megaraid_sas_fp.c
  create mode 100644 drivers/scsi/megaraid/megaraid_sas_fusion.c
  create mode 100644 drivers/scsi/megaraid/megaraid_sas_fusion.h

which makes those line numbers look at least a _bit_ better, since
that megaraid_sas_base.c file is pretty big.

                         Linus

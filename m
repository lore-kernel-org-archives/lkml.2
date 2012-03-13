Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab2CMCui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:50:38 -0400
Received: from mga12.intel.com ([143.182.124.36]:44715 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759399Ab2CMCug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:50:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120313134512.848baf17f46729fa0fac195d@canb.auug.org.au>
References: <20120313134512.848baf17f46729fa0fac195d@canb.auug.org.au>
Date: Mon, 12 Mar 2012 19:50:33 -0700
Message-ID: <CABE8wwtNcA4QcJyLC6zipjygjAYa6o=bwPyz6xS9A=PLiU+2kg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the isci tree with the scsi tree
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 7:45 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dan,
>
> Today's linux-next merge of the isci tree produced a large number of
> conflicts against the scsi.
>
>  Merging isci/all
> +CONFLICT (content): Merge conflict in include/scsi/sas_ata.h
>  CONFLICT (content): Merge conflict in include/scsi/libsas.h
> +CONFLICT (content): Merge conflict in include/linux/libata.h
>  CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_scsi_host.c
> +CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_internal.h
>  CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_init.c
>  CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_expander.c
> +CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_event.c
>  CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_discover.c
> +CONFLICT (content): Merge conflict in drivers/scsi/libsas/sas_ata.c
> +CONFLICT (content): Merge conflict in drivers/scsi/isci/request.h
>  CONFLICT (content): Merge conflict in drivers/scsi/isci/registers.h
> +CONFLICT (content): Merge conflict in drivers/scsi/isci/port.h
> +CONFLICT (content): Merge conflict in drivers/scsi/isci/port.c
> +CONFLICT (content): Merge conflict in drivers/scsi/isci/phy.c
>  CONFLICT (content): Merge conflict in drivers/scsi/isci/init.c
>
> Since you are feeding patches into the scsi tree (instaed of having you
> tree merged into the scsi tree), you should rebase your tree in the scsi
> tree after your patches have been accepted.  The above conflicts are
> (almost completely) caused by having the same patches in both trees with
> additional changes to those files in your tree.

I was wondering why it had not happened prior to this point...  in any
event I'll get my tree rebased on top scsi-misc so that isci.git#all
will just be the pending delta.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2JOVfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:35:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37491 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2JOVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:35:32 -0400
Date: Mon, 15 Oct 2012 22:38:54 -0700
From: Daniel Cotey <puff65537@bansheeslibrary.com>
To: Chad Williamson <chad@dahc.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] staging: silicom: coding style fixes for bp_proc.c
Message-ID: <20121016053854.GA6665@elbert.example.com>
References: <1350297039-8166-1-git-send-email-chad@dahc.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350297039-8166-1-git-send-email-chad@dahc.us>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 05:30:34AM -0500, Chad Williamson wrote:
> This patch set corrects many of the coding style issues detected by
> checkpatch.pl in bp_proc.c.
> 
> Chad Williamson (5):
>   staging: silicom: fix whitespace in bp_proc.c
>   staging: silicom: fix C99 comments in bp_proc.c
>   staging: silicom: remove parentheses from return statements in bg_proc.c
>   staging: silicom: remove unnecessary braces in bp_proc.c
>   staging: silicom: fix explicit intialization of procfs_dir in bp_proc.c
> 
>  drivers/staging/silicom/bp_proc.c | 82 +++++++++++++++------------------------
>  1 file changed, 31 insertions(+), 51 deletions(-)
> 
> -- 
> 1.7.12.2
> 

Looks good to me (and as soon as asrock support pulls their head out I'll run HW tests).

Regards,
  Daniel Cotey


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2CZH50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:57:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35791 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753895Ab2CZH5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:57:25 -0400
Message-ID: <1332748641.2836.8.camel@dabdike>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>, Greg KH <greg@kroah.com>
Date: Mon, 26 Mar 2012 08:57:21 +0100
In-Reply-To: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
References: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 12:17 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/staging/keucr/scsiglue.c:349:2: error: unknown field 'proc_info' specified in initializer
> drivers/staging/rts_pstor/rtsx.c:258:2: error: unknown field 'proc_info' specified in initializer
> drivers/staging/rts5139/rts51x_scsi.c:2190:2: error: unknown field 'proc_info' specified in initializer
> 
> Caused by commit 104c4fe25dc9 ("[SCSI] remove scsi_host_template::proc_info").
> 
> Since this is a staging driver, I applied these following patches:

Yes, that looks about right, thanks.  We haven't seen anything about
these drivers on the SCSI list, so I've no idea where they are in
development.

James



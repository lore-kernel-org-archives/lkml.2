Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2C0H3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 03:29:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38460 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649Ab2C0H3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 03:29:33 -0400
Message-ID: <1332833369.2883.6.camel@dabdike>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 27 Mar 2012 08:29:29 +0100
In-Reply-To: <20120326140721.GA19827@kroah.com>
References: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
	 <1332748641.2836.8.camel@dabdike> <20120326140721.GA19827@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 07:07 -0700, Greg KH wrote:
> On Mon, Mar 26, 2012 at 08:57:21AM +0100, James Bottomley wrote:
> > On Mon, 2012-03-26 at 12:17 +1100, Stephen Rothwell wrote:
> > > Hi James,
> > > 
> > > After merging the scsi tree, today's linux-next build (x86_64 allmodconfig)
> > > failed like this:
> > > 
> > > drivers/staging/keucr/scsiglue.c:349:2: error: unknown field 'proc_info' specified in initializer
> > > drivers/staging/rts_pstor/rtsx.c:258:2: error: unknown field 'proc_info' specified in initializer
> > > drivers/staging/rts5139/rts51x_scsi.c:2190:2: error: unknown field 'proc_info' specified in initializer
> > > 
> > > Caused by commit 104c4fe25dc9 ("[SCSI] remove scsi_host_template::proc_info").
> > > 
> > > Since this is a staging driver, I applied these following patches:
> > 
> > Yes, that looks about right, thanks.  We haven't seen anything about
> > these drivers on the SCSI list, so I've no idea where they are in
> > development.
> 
> Why is new patches going into your tree right now, during the 3.4 merge
> window?  API changes should have happened weeks ago, to let others fix
> up things like this.

Yes, I'll defer this change to the next merge window.

James

> As for the "where they are in development", they vary, but, a simple
> grep should have shown you that these in-kernel drivers should also be
> fixed up, or at the least, give me the heads up to let me do it for you.
> 
> Care to send me the patch that causes this problem so I can create a fix
> for this?
> 
> thanks,
> 
> greg k-h



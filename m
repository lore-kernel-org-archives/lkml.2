Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0KHRwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:52:38 -0500
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:48796 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752883Ab0KHRwh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:52:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=52kz64pmke2+xfimJ8kDYJioDbp024wqTBRwPWQ8SWV0eYOqvE1P6KzzOoNkpJZ28qMx5X2FxYoIDxv+98W3II6m74ONuiObL1muNE/n/JzvY7LI8g84192Z1ejDdwCtNpcLVFbNE2OBn7VzzY8sPw1av9ZNO64m2X7iz1Rlpkg=;
Message-ID: <732901.49803.qm@web31801.mail.mud.yahoo.com>
X-YMail-OSG: 8CF4ZaAVM1mdFicZvE3hlB7FBAvmBZ9sgE.LxVPeQ1hM2.i
 EVSL5FZDJQLMpLSpFLX5ig0RC5MdQZzlBvzcmbNKwXH5QCGanLWwiCBFkDpa
 T1U3jtExl2C1J6lUh0Hr4k6_vDECJ1GEKJ0qrSGKBLIb4QbVMOublG4pVCuH
 uldGKUaeBd6XOaYxfSVZpAvZKrxMIGL1fsAGSFSQo5haQUUIxJfc_9GjD_C4
 Z8pRwScCDSmOSGrMDO2k0ULu6YoPvL407HO9BTroYDR5nlSe5VoIcaBkEzRj
 vQF4GQL423PlFL2v86AEooIq7GBoxk4GJ_OToaOcypnpscIMD6Lbfbd2yl2g
 3Q.veudM-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Mon, 8 Nov 2010 09:52:36 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/8/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> --- On Mon, 11/8/10, Matthew Wilcox
> <willy@linux.intel.com>
> wrote:
> > -0700, Luben Tuikov wrote:
> > > The reason to do this is to accommodate sending
> > > different IU types using the existing
> > > infrastructure.
> > 
> > Applied, with a modified changelog entry ...
> 
> Again, where is it applied and what is the (new) modified
> changelog entry? Why would you leave this detail out in your
> response to the patch?

Please have some professional integrity and EITHER a) ask me to
resubmit the patch with a new change log (what would you like?) or b) discuss it here publicly.

See my previous post on your other modification of the change log
to my other patch against your code.

> 
> > 
> > >      struct urb *data_out_urb;
> > >      struct list_head list;
> > >  };
> > >  
> > > -/* I hate forward declarations, but I actually
> have a
> > loop */
> > >  static int uas_submit_urbs(struct scsi_cmnd
> > *cmnd,
> > >         
> >         struct uas_dev_info
> > *devinfo, gfp_t gfp);
> > >  
> > 
> > Except for this spurious chunk.
> 
> Sorry, please help us understand: You'll LEAVE a
> self-gratifying, narcissistic and pompous statement like "I
> hate forward-declarations"? Why would you use such a strong
> word? Why would you "hate"? How about: "I don't like" or "I
> know lk style discourages", etc. Why would you add /one
> more/ "hate" word into the kernel?
> 
> I think everyone sees why this forward-decl is needed.
> 
> I wonder if the relation of the number of the "hate" word
> in the linux kernel versus time correlates to something,
> anything? Now that's easier to track and analyze in time
> using git.
> 
> Compared to people losing their homes and jobs nowadays,
> I'll take a forward declaration any time of day and night.
> 
> Bottom line: please consider the patch as is.
> 
> 

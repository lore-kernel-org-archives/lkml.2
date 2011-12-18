Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab1LROpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 09:45:44 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52615 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1LROpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 09:45:42 -0500
Subject: Re: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4EEDFC16.90303@nod.at>
References: <1321572864-23628-1-git-send-email-richard@nod.at>
	 <4EEDFC16.90303@nod.at>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Dec 2011 08:45:40 -0600
Message-ID: <1324219540.3091.28.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-18 at 15:43 +0100, Richard Weinberger wrote:
> Am 18.11.2011 00:34, schrieb Richard Weinberger:
> > scsi_dh_attach() should return a negative value on error.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  include/scsi/scsi_dh.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
> > index e3f2db2..e07ab10 100644
> > --- a/include/scsi/scsi_dh.h
> > +++ b/include/scsi/scsi_dh.h
> > @@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char *name)
> >  }
> >  static inline int scsi_dh_attach(struct request_queue *req, const char *name)
> >  {
> > -	return SCSI_DH_NOSYS;
> > +	return -SCSI_DH_NOSYS;
> >  }
> >  static inline void scsi_dh_detach(struct request_queue *q)
> >  {
> 
> James,
> 
> can you please pickup this patch?

It still needs an ack from rdac people (other one just got overlooked).

James



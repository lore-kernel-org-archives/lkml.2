Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2IMIUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:20:15 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:56812 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab2IMIUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:20:02 -0400
Subject: Re: [PATCH 7/15] drivers/s390/net: removes unnecessary semicolon
From: Ursula Braun <ubraun@linux.vnet.ibm.com>
To: peter.senna@gmail.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        blaschka@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com,
        heicars2@linux.vnet.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <OF869CD991.BF07C10D-ONC1257A78.002BEE03-C1257A78.002BF89E@de.ibm.com>
References: <OF869CD991.BF07C10D-ONC1257A78.002BEE03-C1257A78.002BF89E@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Sep 2012 10:19:54 +0200
Message-ID: <1347524394.9036.3.camel@br9gv9yg.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 12091308-8372-0000-0000-000003BD1CDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Peter. I will schedule these changes for our next posting.

Ursula Braun
> Peter Senna Tschudin <peter.senna@gmail.com> wrote on 12/09/2012 19:03:14:
> 
> > From:
> > 
> > Peter Senna Tschudin <peter.senna@gmail.com>
> > 
> > To:
> > 
> > Ursula Braun1/Germany/IBM@IBMDE
> > 
> > Cc:
> > 
> > trivial@kernel.org, kernel-janitors@vger.kernel.org, Frank Blaschka 
> > <blaschka@linux.vnet.ibm.com>, BOEBLINGEN LINUX390/Germany/
> > IBM@IBMDE, mschwid2@linux.vnet.ibm.com, heicars2@linux.vnet.ibm.com,
> > linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
> > 
> > Date:
> > 
> > 12/09/2012 19:03
> > 
> > Subject:
> > 
> > [PATCH 7/15] drivers/s390/net: removes unnecessary semicolon
> > 
> > From: Peter Senna Tschudin <peter.senna@gmail.com>
> > 
> > removes unnecessary semicolon
> > 
> > Found by Coccinelle: http://coccinelle.lip6.fr/
> > 
> > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> > 
> > ---
> >  drivers/s390/net/ctcm_fsms.c      |    2 +-
> >  drivers/s390/net/qeth_core_main.c |    4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/s390/net/ctcm_fsms.c b/drivers/s390/net/ctcm_fsms.c
> > index d4ade9e..fb92524 100644
> > --- a/drivers/s390/net/ctcm_fsms.c
> > +++ b/drivers/s390/net/ctcm_fsms.c
> > @@ -1523,7 +1523,7 @@ static void ctcmpc_chx_firstio(fsm_instance 
> > *fi, int event, void *arg)
> >              goto done;
> >     default:
> >        break;
> > -   };
> > +   }
> > 
> >     fsm_newstate(fi, (CHANNEL_DIRECTION(ch->flags) == CTCM_READ)
> >             ? CTC_STATE_RXINIT : CTC_STATE_TXINIT);
> > diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/
> > qeth_core_main.c
> > index cf6da7f..0bd86b8 100644
> > --- a/drivers/s390/net/qeth_core_main.c
> > +++ b/drivers/s390/net/qeth_core_main.c
> > @@ -489,7 +489,7 @@ static struct qeth_reply *qeth_alloc_reply
> > (struct qeth_card *card)
> >        atomic_set(&reply->refcnt, 1);
> >        atomic_set(&reply->received, 0);
> >        reply->card = card;
> > -   };
> > +   }
> >     return reply;
> >  }
> > 
> > @@ -2029,7 +2029,7 @@ int qeth_send_control_data(struct qeth_card 
> > *card, int len,
> >           if (time_after(jiffies, timeout))
> >              goto time_err;
> >           cpu_relax();
> > -      };
> > +      }
> >     }
> > 
> >     if (reply->rc == -EIO)
> > 



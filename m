Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1IUDlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 23:41:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54766 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1IUDlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 23:41:42 -0400
Subject: Re: [PATCH v1 4/4] target: check hex2bin result
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Arnaud Lacombe <lacombar@gmail.com>, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
In-Reply-To: <CAHp75VcQd9CjCKHVWjb7pDzFWCHMTcpTrzG4hHfiLu27F+Tfmg@mail.gmail.com>
References: <1316548373-8782-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1316548373-8782-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <CAHp75VcQd9CjCKHVWjb7pDzFWCHMTcpTrzG4hHfiLu27F+Tfmg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 23:41:32 -0400
Message-ID: <1316576492.3287.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 02:55 +0300, Andy Shevchenko wrote:
> On Tue, Sep 20, 2011 at 10:52 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > Now that hex2bin does error checking, on error add debugging error msg.
> >
> > Changelog v1:
> > - hex2bin now returns an int
> >
> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > ---
> >  drivers/target/target_core_fabric_lib.c |   11 +++++++++--
> >  1 files changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> > index c4ea3a9..17658ca 100644
> > --- a/drivers/target/target_core_fabric_lib.c
> > +++ b/drivers/target/target_core_fabric_lib.c
> > @@ -63,6 +63,7 @@ u32 sas_get_pr_transport_id(
> >        unsigned char *buf)
> >  {
> >        unsigned char *ptr;
> > +       bool ret;
> I'm sorry for this, but I guess you meant int?

Sigh, yes of course.  As an after thought, I decided to include the
'target' patch.  :( 
> >
> >        /*
> >         * Set PROTOCOL IDENTIFIER to 6h for SAS
> 
> > @@ -158,6 +161,8 @@ u32 fc_get_pr_transport_id(
> >        unsigned char *ptr;
> >        int i;
> >        u32 off = 8;
> > +       bool ret;
> Ditto.
> > +
> >        /*
> >         * PROTOCOL IDENTIFIER is 0h for FCP-2
> >         *
> Otherwise have my Acked-by. I think Andrew also will be happy.

Thanks for all the reviews/Acks!

Mimi


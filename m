Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab1FWSVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:21:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50496 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928Ab1FWSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:21:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UkjQC0NKzy4C+7bHZxjEkM10Gy7Lq2LrvMV/ushyWh11Re85b4+MohZRVrAQ7qHn+l
         hm3tgWh212x5qsPmg1cleweNFcRE0X5PcrThwLT9dKmeW74s34iH0JScmxS5cmAfnZ/Y
         8JaLRVqkkGrSE4xMFh+tJ9bBUhoS7wBzF8sOc=
Date: Thu, 23 Jun 2011 11:21:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Olaf Hering <olaf@aepfle.de>, stable@kernel.org,
        linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [34-longterm 210/247] Input: xen-kbdfront - advertise either
 absolute or relative coordinates
Message-ID: <20110623182125.GB14950@core.coreip.homeip.net>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-151-git-send-email-paul.gortmaker@windriver.com>
 <20110623175725.GA21283@aepfle.de>
 <BANLkTi=5nCHt370=6ZWg4ePLi1qh0w51cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=5nCHt370=6ZWg4ePLi1qh0w51cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 02:14:48PM -0400, Paul Gortmaker wrote:
> On Thu, Jun 23, 2011 at 1:57 PM, Olaf Hering <olaf@aepfle.de> wrote:
> > On Thu, Jun 23, Paul Gortmaker wrote:
> >
> >> From: Olaf Hering <olaf@aepfle.de>
> >>
> >>                    -------------------
> >>     This is a commit scheduled for the next v2.6.34 longterm release.
> >>     If you see a problem with using this for longterm, please comment.
> >>                    -------------------
> >>
> >> commit 8c3c283e6bf463ab498d6e7823aff6c4762314b6 upstream.
> >
> > This one will introduce a regression, which will be fixed by upstream
> > commit c36b58e8a9112017c2bcc322cc98e71241814303
> >
> >    Input: xen-kbdfront - fix mouse getting stuck after save/restore
> >
> > Olaf
> 
> Thanks Olaf,  it will appear here shortly.
> 
> http://git.kernel.org/?p=linux/kernel/git/longterm/longterm-queue-2.6.34.git;a=summary
> 
> [PS: Dmitry - the mail.ru address you've been using in SOB lines always bounces]

Hmm, that is wierd. I am getting mail to that address, in fact I just
reseived a letter from Jarod Wilson there...

I am not sure why they don't like your mails but that is the reason I am
keeping both mail.ru and gmail.com addresses.

Thanks.

-- 
Dmitry

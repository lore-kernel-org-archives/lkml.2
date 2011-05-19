Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1ESWpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:45:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40689 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ESWpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:45:31 -0400
Subject: Re: [PATCH v5 01/21] integrity: move ima inode integrity data
 management
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20110519020619.GA10188@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1305557115-15652-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110519020619.GA10188@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 18:45:21 -0400
Message-ID: <1305845121.2528.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 21:06 -0500, Serge E. Hallyn wrote: 
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > Move the inode integrity data(iint) management up to the integrity directory
> > in order to share the iint among the different integrity models.
> 
> You also
> 
>   rename several globally visible ima_* functions, structs, locks etc to
>      integrity_\0
>   replace '20' by SHA1_DIGEST_SIZE
>   remove unnecessary initialization of iint_initialized to 0

Yes, will update the changelog to reflect these changes as well.

> Which all are fine, but probably should be mentioned in changelog,
> along with the magic phrase "no other functional changes" to aid
> reviewers.

Wasn't aware of this.

> > Changelog:
> >    - Rebased on current ima_iint.c
> >    - Define integrity_iint_store/lock as static
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> 
> thanks,
> -serge

Thanks!

Mimi 


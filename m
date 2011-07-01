Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1GACCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:02:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:13159 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab1GACCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <1309473473.2857.5.camel@localhost.localdomain>
References: <CA323325.7D40%ryan.r.ware@intel.com>
	<1309473473.2857.5.camel@localhost.localdomain>
Date: Thu, 30 Jun 2011 19:02:28 -0700
Message-ID: <BANLkTinSwVnZ=Yg2HTVSqDN2Qx9rOLJsqw@mail.gmail.com>
Subject: Re: [PATCH v7 00/16] EVM
From: "Ware, Ryan R" <ryan.r.ware@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 3:37 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
> On Thu, 2011-06-30 at 14:06 -0700, Ryan Ware wrote:
> > Glad to see this going in Mimi!  Looking forward to enabling this in our
> > MeeGo kernels.
> >
> > Ryan
>
> I wish.  As far as I'm aware, EVM hasn't been upstreamed.  The good news
> is that the ecryptfs encrypted-key patches are now in the
> security-testing tree.

True.  My wording should have been clearer.  It's definitely good to
have the ecryptfs patches in.

>
> > On 6/29/11 12:50 PM, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:
> >
> > >Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
> > >protect the integrity of a running system from unauthorized changes. When
> > >these protections are not running, such as when booting a malicious OS,
> > >mounting the disk under a different operating system, or physically moving
> > >the disk to another system, an "offline" attack is free to read and write
> > >file data/metadata.
> > >
> > >...snip...
> >
> >
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab1F3Wh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:37:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43715 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1F3Wh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:37:56 -0400
Subject: Re: [PATCH v7 00/16] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Ryan Ware <ware@linux.intel.com>
Cc: "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
In-Reply-To: <CA323325.7D40%ryan.r.ware@intel.com>
References: <CA323325.7D40%ryan.r.ware@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 18:37:53 -0400
Message-ID: <1309473473.2857.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 14:06 -0700, Ryan Ware wrote:
> Glad to see this going in Mimi!  Looking forward to enabling this in our
> MeeGo kernels.
> 
> Ryan

I wish.  As far as I'm aware, EVM hasn't been upstreamed.  The good news
is that the ecryptfs encrypted-key patches are now in the
security-testing tree.

thanks,

Mimi

> On 6/29/11 12:50 PM, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:
> 
> >Discretionary Access Control(DAC) and Mandatory Access Control(MAC) can
> >protect the integrity of a running system from unauthorized changes. When
> >these protections are not running, such as when booting a malicious OS,
> >mounting the disk under a different operating system, or physically moving
> >the disk to another system, an "offline" attack is free to read and write
> >file data/metadata.
> >
> >...snip...
> 
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964Ab1ITN2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:28:18 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48882 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab1ITN2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:28:16 -0400
Subject: Re: [RFC v2.1 0/6] evm: digital signature verification extension
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: herbert@gondor.hengli.com.au
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, Greg KH <greg@kroah.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
In-Reply-To: <cover.1315921427.git.dmitry.kasatkin@intel.com>
References: <cover.1315921427.git.dmitry.kasatkin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 09:24:28 -0400
Message-ID: <1316525069.3189.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
x-cbid: 11092013-5112-0000-0000-0000007811F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 17:20 +0300, Dmitry Kasatkin wrote: 
> Hello,
> 
> Changes to version 2.0:
> - MPI patch has been split to smaller in order to go to mailing lists.
>   First 2 patches include only source and header files which are needed
>   to build ksign verification. Headers and sources are split just to
>   meet 100k kernel.org limit.
>   Last patch adds all rest soures from original ported MPI library.
>   
> Changes to version 1.1:
> - GnuPG MPI library has been refactored with lindent and checkpatch errors
>   and warnings has been fixed.
> - creation of evm keyring has been remove. It is done now in user space.
> - related ksign and evm patches has been squashed.
> - patch descriptions has been updated.
> 
> As EVM patches were recently merged to security-testing-2.6#next,
> it is a good time to resend evm signature verification patches for active
> discussion. Last time I forgot --cc linux-crypto. Here it is.
> 
> This patchset introduces digital signature extensions for the IMA/EVM kernel
> integrity subsystem and is applied on the top of the EVM patches posted to
> LSM mailing list earlier.

Hi Herbert

Back in March 2011, in preparation for EVM, Dmitry posted the GnuPG MPI
library patch here on linux-crypto. The reason given for not upstreaming
the MPI library, at the time, was for lack of an in kernel user
(http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg05613.html).
With the recent merging of the EVM patches in linux-next, via
security-testing-2.6/#next, that is changing.  Any chance of re-opening
the discussion? 

thanks,

Mimi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab2HPT7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:59:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49735 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab2HPT7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:59:17 -0400
Message-ID: <1345147067.3402.26.camel@falcor.watson.ibm.com>
Subject: Re: [RFC v2 6/7] modsig: initialize the _module public key keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Date: Thu, 16 Aug 2012 15:57:47 -0400
In-Reply-To: <CA+5PVA6Ah-mCiSSRC+TJ0vYq-OHxn4_+-iNpErjGiYO3tbeOtQ@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	 <ba3d3f54baf08e7252312fa51e590e5d0ca50206.1345055639.git.dmitry.kasatkin@intel.com>
	 <CA+5PVA6Ah-mCiSSRC+TJ0vYq-OHxn4_+-iNpErjGiYO3tbeOtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081619-7182-0000-0000-0000024F7CB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 14:54 -0400, Josh Boyer wrote:
> On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
> > From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> >
> > Create and initialize the _module public key keyring with the builtin
> > public key.
> >
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> This seems like it could be folded into "modsig: add
> integrity_module_check hook" or "modsig: verify module integrity based
> on signature".  Not sure why it needs to be a separate patch at first
> glance.

No reason other than my sending it to Dmitry.  I'm sure he can squash it
with his own patches.

thanks,

Mimi


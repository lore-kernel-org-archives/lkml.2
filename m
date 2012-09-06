Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab2IFDA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:00:58 -0400
Received: from ozlabs.org ([203.10.76.45]:59066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab2IFDAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin\, Dmitry" <dmitry.kasatkin@intel.com>,
        David Howells <dhowells@redhat.com>, jmorris@namei.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] module: signature infrastructure
In-Reply-To: <1346852077.2389.7.camel@falcor>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk> <87627ufi2h.fsf@rustcorp.com.au> <CALLzPKaA3MYncJD1X6B8f3p-R6FVA5-WDF-h6GGwdtinNpjqmw@mail.gmail.com> <871uihl3bx.fsf@rustcorp.com.au> <1346852077.2389.7.camel@falcor>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 11:35:26 +0930
Message-ID: <87harbj47t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

> On Wed, 2012-09-05 at 09:59 +0930, Rusty Russell wrote:
>> "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> writes:
>> > Hi,
>> >
>> > Please read bellow...
>> >
>> > On Tue, Sep 4, 2012 at 8:55 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> >> OK, I took a look at the module.c parts of David and Dmitry's patchsets,
>> >> and didn't really like either, but I stole parts of David's to make
>> >> this.
>> >>
>> >> So, here's the module.c part of module signing.  I hope you two got time
>> >> to discuss the signature format details?  Mimi suggested a scheme where
>> >> the private key would never be saved on disk (even temporarily), but I
>> >> didn't see patches.  Frankly it's something we can do later; let's aim
>> >> at getting the format right for the next merge window.
>> >
>> > In our patches key is stored on the disc in encrypted format...
>> 
>> Oh, I missed that twist.  Thanks for the explanation.
>> 
>> On consideration, I prefer signing to be the final part of the "modules"
>> target rather than modules_install.  I run the latter as root, and that
>> is wrong for doing any code generation.
>
> Agreed, but keep in mind that 'modules_install' could subsequently strip
> the module.

That had better be part of your signing step then!

Cheers,
Rusty.

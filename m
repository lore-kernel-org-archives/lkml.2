Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2FEOgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 10:36:48 -0400
Received: from mga05.intel.com ([192.55.52.89]:58232 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758092Ab2FEOgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 10:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <18630.1338903474@redhat.com>
References: <20120522230218.24007.3556.stgit@warthog.procyon.org.uk>
	<26029.1337960539@redhat.com>
	<87ipf73lsi.fsf@rustcorp.com.au>
	<1338814071.4044.19.camel@falcor>
	<87wr3min4b.fsf@rustcorp.com.au>
	<1338896342.4044.117.camel@falcor>
	<18630.1338903474@redhat.com>
Date: Tue, 5 Jun 2012 17:36:41 +0300
Message-ID: <CALLzPKYpAJ4AtiWJgDiqbJnJa-UUCChdv=bUJAwB0iV4=WVoMg@mail.gmail.com>
Subject: Re: [PATCH 00/23] Crypto keys and module signing
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, kyle@mcmartin.ca,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, Tim Abbott <tabbott@ksplice.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 4:37 PM, David Howells <dhowells@redhat.com> wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
>> As the signature would be stored as an extended attribute, we wouldn't
>> need to pass it.  Unfortunately not all filesystems have xattr support,
>> nor do all of the package installation mechanims.  The benefit of
>> storing the signature as an extended attribute, however, is that there
>> is a consistent mechanism for verifying file data integrity for all
>> files, not only ELF.
>
> We also want to be able to do module signature verification with CONFIG_IMA=n.

Sure. In the patchset I sent some time ago, signature verification
does not require CONFIG_IMA=y.
modprobe reads signature from xattr or .sig file and pass it as kernel
module parameter.

- Dmitry


>
> David

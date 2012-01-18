Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab2ARK4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:56:20 -0500
Received: from mga10.intel.com ([192.55.52.92]:19304 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752938Ab2ARK4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:56:18 -0500
MIME-Version: 1.0
In-Reply-To: <21109.1326814340@redhat.com>
References: <20111202184229.21874.25782.stgit@warthog.procyon.org.uk>
	<20111202184354.21874.57647.stgit@warthog.procyon.org.uk>
	<1326718394.2276.1.camel@falcor>
	<21109.1326814340@redhat.com>
Date: Wed, 18 Jan 2012 12:56:15 +0200
Message-ID: <CALLzPKY87L_GTP57MwA=iz4Cn3inboBszJ5OfOSYtUcRJn4KQg@mail.gmail.com>
Subject: Re: [PATCH 07/21] KEYS: Create a key type that can be used for
 general cryptographic operations [ver #3]
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, arjan.van.de.ven@intel.com,
        alan.cox@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 5:32 PM, David Howells <dhowells@redhat.com> wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
>> Nice! Basically the 'crypto' key type ties crypto/ with security/keys.
>> Other than the posted pgp key parser used for verifying kernel module
>> signatures, I assume another use case could be to expose kernel
>> cryptography to userspace.  As there was a submission
>> https://lkml.org/lkml/2010/8/20/103 to do just this, there must be
>> userspace apps that would benefit.  This architecture would address a
>> number of concerns raised with the prior submission. (Refer to
>> http://lwn.net/Articles/401548/.)
>
> :-)
>
>> You'd probably want to move the 'crypto' key type to its own directory.
>
> Yeah.
>
> I'd also like to see if Dmitry's work can be absorbes into this infrastructure.
>

Hi David,

Crypto keys is very nice idea.
We thought some time ago about having dedicated key type for handling
public key cryptography operations,
but did not go that far. Also I did not want to mess-up with GnuPG
formats and just made straight-forward RSA implementation,
which can be handled by any crypto library, such as openssl.
We can easily take GPG signing scheme into use for IMA/EVM when it
gets to upstream.

- Dmitry

> David

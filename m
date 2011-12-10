Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab1LJLmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 06:42:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62846 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1LJLmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 06:42:37 -0500
MIME-Version: 1.0
In-Reply-To: <28442.1323269262@redhat.com>
References: <28442.1323269262@redhat.com>
Date: Sat, 10 Dec 2011 12:42:36 +0100
Message-ID: <CA+MtwOEHYu1z8TLXv7jwCKfgavaGX7EWXmxq2xs6b0jbujy35g@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto keys and module signing
From: =?ISO-8859-2?Q?Arkadiusz_Mi=B6kiewicz?= <a.miskiewicz@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 3:47 PM, David Howells <dhowells@redhat.com> wrote:
>
> Hi James,
>
> Could you pull my module signing code into the security tree?  The patches can
> be viewed here:
>
> http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel

If I understand it is not possible to sign modules after they are
built and load keys without actually
rebuilding kernel?

For distro kernel the public and secret keys have to be available
publicly, right? Otherwise people
using distro kernels won't be able to build own signed modules for use
with that distro kernel.

Then I as admin have to rebuild the kernel to get my own keys in and
prevent other, "unapproved" modules
to be loaded. Correct?

Would be nice if the modules could be signed/re-signed after being
build and prehaps kernel could
load keys from initramfs? Then everyone could use own keys on distro
kernels without need to rebuild
the thing.

I think I'm missing something :)

-- 
Arkadiusz Mi¶kiewicz

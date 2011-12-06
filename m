Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab1LFAzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:55:01 -0500
Received: from tundra.namei.org ([65.99.196.166]:42166 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab1LFAy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:54:59 -0500
Date: Tue, 6 Dec 2011 11:54:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, keyrings@linux-nfs.org,
        alan.cox@intel.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, dmitry.kasatkin@intel.com,
        linux-crypto@vger.kernel.org, arjan.van.de.ven@intel.com,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [Keyrings] [RFC][PATCH 00/16] Crypto keys and module signing
 [ver #2]
In-Reply-To: <776.1323085419@redhat.com>
Message-ID: <alpine.LRH.2.00.1112061151520.25445@tundra.namei.org>
References: <4EDCABBD.9020401@intel.com> <20111129234258.13625.21153.stgit@warthog.procyon.org.uk> <776.1323085419@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, David Howells wrote:

> However, we don't have to include the DSA stuff in the kernel; I can always
> discard that patch from the upstream-aimed patchset.

I'd encourage dropping DSA, as there appears to be no legacy justification 
for its inclusion. 


- James
-- 
James Morris
<jmorris@namei.org>

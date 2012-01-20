Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab2ATBxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:53:07 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:53625 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab2ATBxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:53:05 -0500
Date: Fri, 20 Jan 2012 12:52:51 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dmitry.kasatkin@intel.com, dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: Re: [PATCH 08/21] KEYS: Add signature verification facility [ver
	#3]
Message-ID: <20120120015251.GA8436@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31888.1326916778@redhat.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
> 
>> I thought about export/import.
>> But I think export/Import is hash driver implementation specific...
>> Cannot use ahash state for shash...
> 
> Yeah...  I'll have to consult Herbert Xu about that.

export/import is meant to be work across implementations.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

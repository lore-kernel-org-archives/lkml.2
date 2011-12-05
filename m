Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1LELc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:32:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56230 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912Ab1LELc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:32:27 -0500
Message-ID: <4EDCABBD.9020401@intel.com>
Date: Mon, 05 Dec 2011 03:32:13 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan.van.de.ven@intel.com, alan.cox@intel.com
Subject: Re: [RFC][PATCH 00/16] Crypto keys and module signing [ver #2]
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 03:42 PM, David Howells wrote:
> 
> I have provided a couple of subtypes: DSA and RSA.  Both types have signature
> verification facilities available within the kernel, and both can be used for
> module signature verification with any encryption algorithm known by the PGP
> parser, provided the appropriate algorithm is compiled directly into the
> kernel.
> 

Do we really need the complexity of a full OpenPGP parser?  Parsers are
notorious security problems.  Furthermore, using DSA in anything but a
hard legacy application is not something you want to encourage, so why
support DSA?

	-hpa

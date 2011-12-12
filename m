Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1LLONW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:13:22 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:45801 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752360Ab1LLONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:13:20 -0500
Date: Mon, 12 Dec 2011 09:12:55 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: David Howells <dhowells@redhat.com>
Cc: =?us-ascii?B?PT9JU08tODg1OS0yP1E/QXJrYWRpdXN6X01pPUI2a2lld2ljej89?= 
	<a.miskiewicz@gmail.com>,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        arjan@linux.intel.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
Message-ID: <20111212141255.GA1105@elliptictech.com>
References: <CA+MtwOEHYu1z8TLXv7jwCKfgavaGX7EWXmxq2xs6b0jbujy35g@mail.gmail.com>
 <28442.1323269262@redhat.com>
 <21891.1323521411@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21891.1323521411@redhat.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-10 12:50 +0000, David Howells wrote:
> Arkadiusz Miśkiewicz <a.miskiewicz@gmail.com> wrote:
> > and prehaps kernel could load keys from initramfs?
> 
> How do you trust the keys?  If you have a TPM, then yes you can do that.

Exactly the same way you trust the kernel image itself.  If you can't
trust the integrity of your initramfs (and thus the keys stored within
it), then you also cannot trust the integrity of the kernel image and
thus this whole signing exercise is moot.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

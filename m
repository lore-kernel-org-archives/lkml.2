Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1LISSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:18:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:3317 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1LISSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:18:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="85492618"
Message-ID: <4EE250E0.6090104@linux.intel.com>
Date: Fri, 09 Dec 2011 10:18:08 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
References: <alpine.LRH.2.00.1112100128470.26387@tundra.namei.org> <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org> <28442.1323269262@redhat.com> <2409.1323422253@redhat.com> <4EE2191E.8070107@linux.intel.com> <11634.1323454017@redhat.com>
In-Reply-To: <11634.1323454017@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/2011 10:06 AM, David Howells wrote:
> James Morris <jmorris@namei.org> wrote:
> 
>> Is there any reason not to sign and verify kernel modules by default?
> 
> If you don't have an entropy source, your build can hang if it's waiting for
> gpg to generate a key.  You need to run rngd to get around this.

... the temp key can use /dev/urandom.
seriously, /dev/urandom for one time, temp keys is not bad
(if you care about the difference, you better provide your own real key)


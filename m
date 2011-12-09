Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1LISHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:07:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab1LISHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:07:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.1112100128470.26387@tundra.namei.org>
References: <alpine.LRH.2.00.1112100128470.26387@tundra.namei.org> <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org> <28442.1323269262@redhat.com> <2409.1323422253@redhat.com> <4EE2191E.8070107@linux.intel.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Arjan van de Ven <arjan@linux.intel.com>,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
Date: Fri, 09 Dec 2011 18:06:57 +0000
Message-ID: <11634.1323454017@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> Is there any reason not to sign and verify kernel modules by default?

If you don't have an entropy source, your build can hang if it's waiting for
gpg to generate a key.  You need to run rngd to get around this.

David

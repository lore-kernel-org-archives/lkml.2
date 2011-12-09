Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1LIOcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:32:12 -0500
Received: from tundra.namei.org ([65.99.196.166]:45533 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab1LIOcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:32:09 -0500
Date: Sat, 10 Dec 2011 01:31:49 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
In-Reply-To: <4EE2191E.8070107@linux.intel.com>
Message-ID: <alpine.LRH.2.00.1112100128470.26387@tundra.namei.org>
References: <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org> <28442.1323269262@redhat.com> <2409.1323422253@redhat.com> <4EE2191E.8070107@linux.intel.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Dec 2011, Arjan van de Ven wrote:

> the best way to deal is to have KBUILD generate a key on demand ;-)

Yes -- I'd like to see this code do something useful by default when 
enabled, so yes, create a local key during the build, possibly 
configurable via kconfig.

Is there any reason not to sign and verify kernel modules by default?



- James
-- 
James Morris
<jmorris@namei.org>

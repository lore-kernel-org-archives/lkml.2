Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422825Ab2KNNBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:01:31 -0500
Received: from multi.imgtec.com ([194.200.65.239]:51627 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422711Ab2KNNBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:01:30 -0500
Message-ID: <50A39627.6020809@imgtec.com>
Date: Wed, 14 Nov 2012 13:01:27 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [arc-linux-dev] Re: UAPI for new arches (was Re: [GIT PULL] User
 API Disintegrate: Preparatory patches)
References: <50A0D634.20005@synopsys.com> <C2D7FE5348E1B147BCA15975FBA230750D9832@in01wembx1.internal.synopsys.com> <509251CA.8050008@synopsys.com> <18137.1349203013@warthog.procyon.org.uk> <CAAG0J9_gYLn5+4j9WUnPmxWyJfQK_b8e5xjxZdRPG21euXoCFg@mail.gmail.com> <CAAG0J9_LZ5Q1fNdcbSOyieesabkqcTMT0ueEDLXmemV2C_+F=g@mail.gmail.com>,<8419.1352387261@warthog.procyon.org.uk> <14356.1352416788@warthog.procyon.org.uk> <9377.1352726040@warthog.procyon.org.uk>
In-Reply-To: <9377.1352726040@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_11_14_13_01_28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

The disintegration scripts strip out the #ifdef __KERNEL__ from the
headers in both uapi/ and the old directories. However there are still a
bunch of unexported headers through the tree which have #ifdef
__KERNEL__ in them, usually guarding the entire file (just grep
__KERNEL__ in arch/).

Is this something that you're already planning to eliminate? We have a
few in the metag tree too, and now that uapi/ is nicely separated I'm
not sure if it's worth removing the __KERNEL__ guards or keeping them to
match other architectures.

Thanks
James


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0LGUps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:45:48 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27941 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0LGUpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:45:47 -0500
MIME-Version: 1.0
Message-ID: <dd88185d-bc2c-4d65-8730-8b1fc712306a@default>
Date: Tue, 7 Dec 2010 12:43:28 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Chris Mason <chris.mason@oracle.com>, akpm@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        minchan.kim@gmail.com
Subject: RE: [PATCH V0 1/4] kztmem: simplified radix tree data structure
 support
References: <20101207180653.GA28115@ca-server1.us.oracle.com>
In-Reply-To: <20101207180653.GA28115@ca-server1.us.oracle.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH V0 1/4] kztmem: simplified radix tree data structure support
> 
> [PATCH V0 1/4] kztmem: simplified radix tree data structure support

A monolithic patch containing all of kztmem, cleancache, and frontswap
that applies cleanly to 2.6.36 can be found at:

http://oss.oracle.com/projects/tmem/dist/files/kztmem/kztmem-linux-2.6.36-101207.patch 

(Or http://oss.oracle.com/projects/tmem and Downloads and kztmem patches)
       
I'm a git novice but can prepare a git tree also if desired.

To try kztmem:

1) apply the monolithic patch to 2.6.36
2) rebuild your config ensuring that CONFIG_KZTMEM, CONFIG_CLEANCACHE,
   CONFIG_FRONTSWAP, and CONFIG_ZRAM (for xvMalloc) become enabled
3) rebuild and reboot with "kztmem" as a kernel boot parameter
4) see /sys/kernel/mm/kztmem/* for statistics... note that with
   lots of RAM and no swapping, little or no activity will be seen

As I said, there are known weird bugs that may or may not show
up in your configuration and build environment, so be prepared
in advance that the kernel may crash... removing kztmem as
a boot parameter should disable kztmem and result in a normal boot.

Thanks in advance for trying and testing (and, if you are so
inclined, debugging) kztmem!  I'll be happy to answer any
questions on- or off-list!

Dan

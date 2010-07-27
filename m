Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab0G0S3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:29:53 -0400
Received: from tex.lwn.net ([70.33.254.29]:50809 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0G0S3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:29:52 -0400
Date: Tue, 27 Jul 2010 12:29:49 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7][memcg] virtually indexed array library.
Message-ID: <20100727122949.3bfbfd0a@bike.lwn.net>
In-Reply-To: <20100727165303.7d7d18e9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100727165303.7d7d18e9.kamezawa.hiroyu@jp.fujitsu.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 16:53:03 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This virt-array allocates a virtally contiguous array via get_vm_area()
> and allows object allocation per an element of array.

Quick question: this looks a lot like the "flexible array" mechanism
which went in around a year ago, and which is documented in
Documentation/flexible-arrays.txt.  I'm not sure we need two of
these...  That said, it appears that there are still no users of
flexible arrays.  If your virtually-indexed arrays provide something
that flexible arrays don't, perhaps your implementation should replace
flexible arrays?

Thanks,

jon

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2BOEW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 23:22:27 -0500
Received: from ozlabs.org ([203.10.76.45]:38914 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab2BOEWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 23:22:25 -0500
Date: Wed, 15 Feb 2012 15:16:09 +1100
From: Paul Mackerras <paulus@samba.org>
To: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, Amerigo Wang <amwang@redhat.com>,
        Kexec-ml <kexec@lists.infradead.org>, Milton Miller <miltonm@bga.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH v6 00/10] fadump: Firmware-assisted dump support for
 Powerpc.
Message-ID: <20120215041608.GA15258@bloggs.ozlabs.ibm.com>
References: <20111210064301.10195.3344.stgit@mars.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111210064301.10195.3344.stgit@mars.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 12:19:59PM +0530, Mahesh J Salgaonkar wrote:

> The most of the code implementation has been adapted from phyp assisted dump
> implementation written by Linas Vepstas and Manish Ahuja.

When you repost the series, please be explicit about what the
relationship between the new fadump facility and the old phyp-dump
is, both in the documentation you're adding and in the patch
descriptions.

I gather that fadump uses the same firmware interfaces as phyp-dump,
and can be characterised as a rewrite of phyp-dump.  It would be good
if you would explicitly mention:

- What advantages fadump has over phyp-dump
- Whether there are any capabilities that phyp-dump does that fadump
  doesn't
- What is different between fadump and phyp-dump in the interface to
  usermode code
- Any user-visible differences between how fadump operates compared to
  phyp-dump.  For example, will users see a difference in how much
  memory is available to the kernel?

Paul.


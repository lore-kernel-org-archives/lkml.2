Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0DGB3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:29:00 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:46134 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab0DGB2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:28:54 -0400
Date: Tue, 6 Apr 2010 18:28:53 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Yinghai <yinghai.lu@oracle.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [2.6.34-rc1 REGRESSION] ahci 0000:00:1f.2: controller reset
	failed (0xffffffff)
Message-ID: <20100407012853.GE29192@hexapodia.org>
References: <20100406225425.GA8292@hexapodia.org> <4BBBDAF4.4020304@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBBDAF4.4020304@oracle.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 06:08:04PM -0700, Yinghai wrote:
> > [    3.094038] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> > [    3.103001] pci 0000:00:1f.2: can't reserve [mem 0xff970000-0xff9707ff]
> > 
> > so I've CCed a few recent committers to setup-res.c.
> 
> can you try to boot with pci=nocrs ?

That boots and configures the AHCI just fine.

> also please check with -rc4.

All I see in git is -rc3 + 299 commits ending with 0fdf867...

That still fails with the same "controller reset failed" message from
ahci.

-andy

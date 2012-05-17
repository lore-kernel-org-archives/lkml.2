Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab2EQGfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:35:14 -0400
Received: from mga10.intel.com ([192.55.52.92]:28776 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757417Ab2EQGfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:35:12 -0400
Subject: Re: Boot error: x86/efi/ioremap kconfig:x86_64-nfsroot
 commit:a790068
From: Matt Fleming <matt.fleming@intel.com>
To: wfg@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120517030652.GA8188@localhost>
References: <20120517030652.GA8188@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 17 May 2012 07:34:55 +0100
Message-ID: <1337236495.27692.27.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 11:06 +0800, wfg@linux.intel.com wrote:
> Hi Matt,
> 
> FYI, starting from this commit, the kernel immediately reboots in my
> kvm boot tests..

Hi Fengguang,

Yeah, this commit is broken. I pushed it to my repository so that I
could test it on all of my machines, but quickly discovered that it
contains some bugs.

How come you are running are kernel built from that branch? I only
created it yesterday. The majority of branches in my repository are work
in progress, at least until they appear in a pull request on lkml. Which
means they may contain blatantly broken commits.

But anyway, thanks for testing as it confirms that the commit is indeed
buggy!


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab2EQILv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:11:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:18712 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab2EQILo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:11:44 -0400
Subject: Re: Boot error: x86/efi/ioremap kconfig:x86_64-nfsroot
 commit:a790068
From: Matt Fleming <matt.fleming@intel.com>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120517065922.GA11817@localhost>
References: <20120517030652.GA8188@localhost>
	 <1337236495.27692.27.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120517065922.GA11817@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 17 May 2012 09:11:12 +0100
Message-ID: <1337242272.27692.29.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 14:59 +0800, Fengguang Wu wrote:
> I happen to be building a kernel test backend for our team and
> hopefully for the wider kernel community.
> 
> What I do is to fetch a number of git trees (including yours) into my
> test server, iterate through *all* remote branches and test out *every
> single* commits there.

That is very cool! I'll keep this in mind in future to make sure that my
trees don't contain known buggy commits.



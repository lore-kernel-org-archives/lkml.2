Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0JTTxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:53:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:48495 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0JTTxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,356,1283756400"; 
   d="scan'208";a="338478707"
Message-ID: <4CBF48C7.3050306@linux.intel.com>
Date: Wed, 20 Oct 2010 12:53:43 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/mm] x86, mm: Fix incorrect data type in vmalloc_sync_all()
References: <20101020103642.GA3135@kryptos.osrc.amd.com> <tip-bfac67208d6d2a84fe7980187d3d2f21424dde59@git.kernel.org> <20101020195046.GB16147@aftab>
In-Reply-To: <20101020195046.GB16147@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 12:50 PM, Borislav Petkov wrote:
>> Commit-ID:  bfac67208d6d2a84fe7980187d3d2f21424dde59
>> Gitweb:     http://git.kernel.org/tip/bfac67208d6d2a84fe7980187d3d2f21424dde59
>> Author:     tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Looks like git (or your script) picked up the first From: in the mail as
> author...
> 

Yes, your email started out:


From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Tue, Oct 19, 2010 at 10:17:37PM +0000

> > Commit-ID:  617d34d9e5d8326ec8f188c616aa06ac59d083fe
> > Gitweb:
http://git.kernel.org/tip/617d34d9e5d8326ec8f188c616aa06ac59d083fe
> > Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > AuthorDate: Tue, 21 Sep 2010 12:01:51 -0700
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Tue, 19 Oct 2010 13:57:08 -0700
--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 20 Oct 2010 12:23:48 +0200
Subject: [PATCH] x86, mm: Fix build warning on 32-bit

... and that confused the scripts.  The way git wants it commentary
information should go *after* the "---" line.

(This is a constant problem, by the way: people seems to want to prefix,
not suffix, their commentary; "cover letter" style.)  I suspect git
needs to change, but it's hard to know exactly how to change it.

	-hpa

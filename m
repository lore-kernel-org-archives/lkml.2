Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0JEQan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:30:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:22960 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab0JEQal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:30:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,284,1283756400"; 
   d="scan'208";a="560911964"
Message-ID: <4CAB52AD.60502@linux.intel.com>
Date: Tue, 05 Oct 2010 09:30:37 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, torvalds@linux-foundation.org, ryan@innosecc.com,
        tglx@linutronix.de
Subject: Re: [tip:x86/cpu] x86, cpu: Fix X86_FEATURE_NOPL
References: <20101004073127.GA20305@liondog.tnic> <tip-366d4a43b1a7a861c356a0e407c4f03f454d42ea@git.kernel.org> <20101005094712.GA5626@a1.tnic>
In-Reply-To: <20101005094712.GA5626@a1.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2010 2:47 AM, Borislav Petkov wrote:
>
> tag it for -stable too?
>

What is the flaw that justifies it for stable, or even .36?  It seems 
relatively harmless, with at most a very minor performance issue, unless 
I'm missing something?

	-hpa


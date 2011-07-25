Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1GYKeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:34:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39381 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1GYKd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:33:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bob Zhang <zhanglinbao@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hayfeng Lee <omycle@gmail.com>, ak@linux.intel.com,
        Bob Zhang <2004.zhang@gmail.com>
References: <5f6c52c61003241920i6b3eaaf7k946f67d1a6f9e384@mail.gmail.com>
	<m1r5n7ln0l.fsf@fess.ebiederm.org>
	<CAKdQVUZMC0eaeqev=tAbS2myHJOA1KJt4r8TVMz6=yQeDpUpZQ@mail.gmail.com>
	<CAKdQVUaKea64ROeDo-SLRgQ3sHptyxD2TjKKgK5OmS+28Ee1zw@mail.gmail.com>
Date: Mon, 25 Jul 2011 03:33:53 -0700
In-Reply-To: <CAKdQVUaKea64ROeDo-SLRgQ3sHptyxD2TjKKgK5OmS+28Ee1zw@mail.gmail.com>
	(Bob Zhang's message of "Mon, 25 Jul 2011 18:17:05 +0800")
Message-ID: <m1ei1ewsxa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX189Ptl8aDLsJ4/mmBWdTUCUOmXY7awF2eE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bob Zhang <zhanglinbao@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: x86_64 virtual memory map
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Zhang <zhanglinbao@gmail.com> writes:

> I have HP's latest Proliant machine , The test involves using
> configurations of 1 TB of Ram then 2TB of RAM. The system ROM is
> reporting the proper amount of installed memory, however, Linux is
> only reporting 992GB with both 1TB and 2 TB of memory in the system.
> The customer has made the changes in the RMSU from 40 to 44 bit
> addressing when using the 2TB of memory but this does not change
> anything.
> I am using SLES 11 SP1 (linux kernel is 2.6.32)
> Does anyone have any idea how to get Linux to see the full amount of
> memory?

What does the e820 map printed by the kernel at the start of time
report?  In particular is all of memory visible there?

Eric


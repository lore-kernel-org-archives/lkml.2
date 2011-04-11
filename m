Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1DKWXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:23:24 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:38357 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753167Ab1DKWXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:23:23 -0400
Message-ID: <4DA37F58.2060604@tlinx.org>
Date: Mon, 11 Apr 2011 15:23:20 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: starting >=2.6.36 FATAL: Setup length exceeds 31 maximum; kernel setup will overwrite boot loader
References: <4D65792C.8070703@tlinx.org>
In-Reply-To: <4D65792C.8070703@tlinx.org>
X-Stationery: 0.5.1
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Fatal: Setup length exceeds 31 maximum; kernel setup will overwrite
> boot loader
> Starting with 2.6.36, I started getting the above message.
...
----
FWIW, the above problem was fixed, recently in the latest
release of LILO, V23.2, which one can download from:
https://alioth.debian.org/frs/?group_id=100507&release_id=1670

I'd seen messages around the net asking about this problem,
so thought I'd post the solution here in case anyone read this
list, or might later be searching for solution.





Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab0F2E6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 00:58:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58368 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab0F2E6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 00:58:00 -0400
Message-ID: <4C297D6F.2030309@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 12:58:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/alternatives] x86, alternatives: Use 16-bit numbers
 for cpufeature index
References: <tip-*@git.kernel.org> <tip-f88731e3068f9d1392ba71cc9f50f035d26a0d4f@git.kernel.org> <4C2474EF.4050902@cn.fujitsu.com> <4C24CCB7.2020806@zytor.com> <4C285625.6000806@cn.fujitsu.com> <4C28F2A1.1030803@linux.intel.com>
In-Reply-To: <4C28F2A1.1030803@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 06/28/2010 12:58 AM, Lai Jiangshan wrote:
>> There is alternative in use_xsave().
>> use_xsave() should return false in my system, but it returns true after this patch applied.
>>
> 
> Does this patch solve your problem?
> 
> 	-hpa
> 
> 

Yeah, It works, thanks a lot!

Lai

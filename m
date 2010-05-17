Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0EQJiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab0EQJiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:38:09 -0400
Message-ID: <4BF10E74.60409@redhat.com>
Date: Mon, 17 May 2010 12:37:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2 0/3] Convert KVM to use FPU API
References: <1274087308-26676-1-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1274087308-26676-1-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 12:08 PM, Sheng Yang wrote:
> Change from v1:
> Use unlazy_fpu() to handle host FPU, avoiding save/restore of host FPU states.
>
>    

Looks good, will wait a bit for more reviews and apply.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


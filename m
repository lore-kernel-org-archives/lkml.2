Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab0EEIMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:12:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0EEIMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:12:48 -0400
Message-ID: <4BE12853.9040503@redhat.com>
Date: Wed, 05 May 2010 11:12:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Shane Wang <shane.wang@intel.com>
CC: hpa@zytor.com, mingo@elte.hu, joseph.cihula@intel.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH][RESEND] intel_txt: enable SMX flag for VMXON in KVM
References: <1273055902-6923-1-git-send-email-shane.wang@intel.com>
In-Reply-To: <1273055902-6923-1-git-send-email-shane.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 01:38 PM, Shane Wang wrote:
> Per Intel SDM 3B 20.7, for IA32_FEATURE_CONTROL MSR
> Bit 1 enables VMXON in SMX operation. If the bit is clear, execution of VMXON in SMX operation causes a general-protection exception.
> Bit 2 enables VMXON outside SMX operation. If the bit is clear, execution of VMXON outside SMX operation causes a general-protection exception.
>
> This patch is to check the correct in/outside-SMX flag when detecting if VMX is disabled by BIOS, and to set in-SMX flag for VMXON after Intel TXT is launched in KVM.
>
>    

Already committed as 9d4b473eeea, I forgot to confirm, sorry.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0CXJ0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:26:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab0CXJ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:26:04 -0400
Message-ID: <4BA9DAA6.3010304@redhat.com>
Date: Wed, 24 Mar 2010 11:25:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] KVM MMU:  check reserved bits only  if CR4.PSE=1 or
 CR4.PAE=1
References: <4BA34ADD.9040903@cn.fujitsu.com>
In-Reply-To: <4BA34ADD.9040903@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 11:58 AM, Xiao Guangrong wrote:
> - Check reserved bits only if CR4.PAE=1 or CR4.PSE=1 when guest #PF occurs
> - Fix a typo in reset_rsvds_bits_mask()
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function


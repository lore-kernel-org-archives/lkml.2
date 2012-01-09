Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab2AIFE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 00:04:58 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43308 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2AIFE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 00:04:57 -0500
Message-ID: <4F0A7567.3000906@linux.vnet.ibm.com>
Date: Mon, 09 Jan 2012 13:04:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/8] KVM: MMU: reduce the size of shadow page structure
 and some cleanup
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12010905-4790-0000-0000-000000BFF95A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 06:13 PM, Xiao Guangrong wrote:

> In this patchset, we observably reduce the size of struct kvm_mmu_page and let
> the code more simple.
> 
> And this patchset have already tested by unittest and
> RHEL.6.1 setup/boot/reboot/shutdown.


Hi Avi, Marcelo,

Could you please apply patch 1, 2, 7 if they are good for you? :)


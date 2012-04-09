Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab2DIOCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:02:02 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39879 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab2DIOCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:02:01 -0400
Message-ID: <4F82EBD1.5060809@linux.vnet.ibm.com>
Date: Mon, 09 Apr 2012 22:01:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <4F82EA4C.1020507@linux.vnet.ibm.com>
In-Reply-To: <4F82EA4C.1020507@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12040914-4790-0000-0000-0000021E638D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 09:55 PM, Xiao Guangrong wrote:


> 
> 
> Okay, let's simplify it as possible:
> 
> - let it only fix the page fault with PFEC.P == 1 && PFEC.W = 0, that means


PFEC.P == 1 && PFEC.W = 1, my typo.


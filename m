Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab1K0MVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:21:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1K0MVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:21:24 -0500
Message-ID: <4ED22B3C.8010704@redhat.com>
Date: Sun, 27 Nov 2011 14:21:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] KVM: optimize memslots searching
References: <4ECE1037.4060300@gmail.com>
In-Reply-To: <4ECE1037.4060300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 11:36 AM, Xiao Guangrong wrote:
> Changelog:
> - rebase it on current kvm tree and some cleanups
>
> This patchset is tested on x86 and build tested on powerpc and ia64
>

Thanks, applied all.

-- 
error compiling committee.c: too many arguments to function


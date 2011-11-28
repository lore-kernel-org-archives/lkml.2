Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1K1PKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:10:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab1K1PKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:10:02 -0500
Message-ID: <4ED3A430.2060608@redhat.com>
Date: Mon, 28 Nov 2011 17:09:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: remove oos_shadow parameter
References: <4ED3811F.1070101@linux.vnet.ibm.com> <4ED381E6.4070309@linux.vnet.ibm.com>
In-Reply-To: <4ED381E6.4070309@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2011 02:43 PM, Xiao Guangrong wrote:
> The unsync code should be stable now, maybe it is the time to remove this
> parameter to cleanup the code a little bit
>

Thanks, all applied.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0I2Ipb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0I2Ipa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:45:30 -0400
Message-ID: <4CA2FCA0.3020208@redhat.com>
Date: Wed, 29 Sep 2010 10:45:20 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: move access code parsing  to FNAME(walk_addr)
 function
References: <4CA1AF52.5080209@cn.fujitsu.com>
In-Reply-To: <4CA1AF52.5080209@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/28/2010 11:03 AM, Xiao Guangrong wrote:
> Move access code parsing from caller site to FNAME(walk_addr) function

Doesn't apply...


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0DWMI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 08:08:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab0DWMI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:08:57 -0400
Message-ID: <4BD18DD2.7020209@redhat.com>
Date: Fri, 23 Apr 2010 15:08:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/10] KVM MMU: allow more page become unsync at getting
 sp time
References: <4BCFE581.8050305@cn.fujitsu.com> <4BCFE911.1030908@cn.fujitsu.com>
In-Reply-To: <4BCFE911.1030908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 09:13 AM, Xiao Guangrong wrote:
> Allow more page become asynchronous at getting sp time, if need create new
> shadow page for gfn but it not allow unsync(level>  0), we should unsync all
> gfn's unsync page
>    

This is something I wanted for a long time.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


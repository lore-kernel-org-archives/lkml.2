Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0EYJc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:32:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab0EYJc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:32:27 -0400
Message-ID: <4BFB9926.7000609@redhat.com>
Date: Tue, 25 May 2010 12:32:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] KVM: MMU: allow more page become unsync at getting
 sp time
References: <4BF91C34.6020904@cn.fujitsu.com> <4BF91C82.8050308@cn.fujitsu.com> <4BFA2DAD.2030601@cn.fujitsu.com>
In-Reply-To: <4BFA2DAD.2030601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 10:41 AM, Xiao Guangrong wrote:
> Allow more page become asynchronous at getting sp time, if need create new
> shadow page for gfn but it not allow unsync(level>  1), we should unsync all
> gfn's unsync page
>    

Both applied, thanks.

-- 
error compiling committee.c: too many arguments to function


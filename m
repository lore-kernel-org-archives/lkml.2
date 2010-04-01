Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0DAQa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639Ab0DAQaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:30:20 -0400
Message-ID: <4BB4897C.6030409@redhat.com>
Date: Thu, 01 Apr 2010 14:54:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM MMU: record reverse mapping for spte only if
 it's writable
References: <4BB45E65.2040006@cn.fujitsu.com> <4BB45EE2.3010000@cn.fujitsu.com>
In-Reply-To: <4BB45EE2.3010000@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 11:52 AM, Xiao Guangrong wrote:
> The read only spte mapping can't hurt shadow page cache,
> so, no need to record it.
>
>    

We do need to keep track of read-only mappings, that's how swapping 
works.  See commit ca335c8f08d.

-- 
error compiling committee.c: too many arguments to function


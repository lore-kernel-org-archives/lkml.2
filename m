Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0D1NBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:01:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab0D1NBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:01:17 -0400
Message-ID: <4BD83198.7060605@redhat.com>
Date: Wed, 28 Apr 2010 16:01:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
References: <4BD8228D.7090708@cn.fujitsu.com>
In-Reply-To: <4BD8228D.7090708@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 02:57 PM, Lai Jiangshan wrote:
> I think users will enable tdp when their hardwares support ept or npt.
> This patch can reduce about 50% kvm mmu memory usage for they.
>
>    

Good one!

-- 
error compiling committee.c: too many arguments to function


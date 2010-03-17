Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0CQK25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0CQK24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:28:56 -0400
Message-ID: <4BA0AEE4.10209@redhat.com>
Date: Wed, 17 Mar 2010 12:28:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_NO_BOOTMEM woes, 2.6.34-rc1
References: <4B9E5211.9000204@redhat.com> <4B9E73D9.7020101@kernel.org> <4BA0AAC8.5000702@redhat.com>
In-Reply-To: <4BA0AAC8.5000702@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 12:11 PM, Avi Kivity wrote:
>
> I reproduced this on x86_64 as well (both physical and virtual), fails 
> earlier this time.
>

Sorry, that was with a crap printk.

-- 
error compiling committee.c: too many arguments to function


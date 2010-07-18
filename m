Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0GROJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:09:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab0GROJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:09:57 -0400
Message-ID: <4C430B31.4050902@redhat.com>
Date: Sun, 18 Jul 2010 17:09:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 4/6] kvm: add host_writable parameter
References: <4C3FC030.2050301@cn.fujitsu.com>
In-Reply-To: <4C3FC030.2050301@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 05:13 AM, Lai Jiangshan wrote:
> add host_writable parameter for some functions,
> no functionality changed, prepare for using RO pages.
>
>    

This simple patch really clarifies the code.

-- 

error compiling committee.c: too many arguments to function


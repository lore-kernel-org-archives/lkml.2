Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab1B1JVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:21:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1B1JVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:21:23 -0500
Message-ID: <4D6B690C.9090206@redhat.com>
Date: Mon, 28 Feb 2011 11:21:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm: better readability of efer_reserved_bits
References: <4D61E147.8050602@cn.fujitsu.com>
In-Reply-To: <4D61E147.8050602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 05:51 AM, Lai Jiangshan wrote:
> use EFER_SCE, EFER_LME and EFER_LMA instead of magic numbers.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function


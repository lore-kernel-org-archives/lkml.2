Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0LPJG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:06:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0LPJGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:06:18 -0500
Message-ID: <4D09D680.1070106@redhat.com>
Date: Thu, 16 Dec 2010 11:06:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm,x86: return true when user space query KVM_CAP_USER_NMI
 extension
References: <4D073F9B.7060002@cn.fujitsu.com>
In-Reply-To: <4D073F9B.7060002@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 11:57 AM, Lai Jiangshan wrote:
> userspace may check this extension in runtime.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function


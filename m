Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1DUIWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab1DUIW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:22:26 -0400
Message-ID: <4DAFE93C.7030102@redhat.com>
Date: Thu, 21 Apr 2011 11:22:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Liu Yuan <namei.unix@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm, ioapic: Fix an error field reference
References: <1303368838-5620-1-git-send-email-namei.unix@gmail.com>
In-Reply-To: <1303368838-5620-1-git-send-email-namei.unix@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 09:53 AM, Liu Yuan wrote:
> From: Liu Yuan<tailai.ly@taobao.com>
>
> Function ioapic_debug() in the ioapic_deliver() misnames
> one filed by reference. This patch correct it.

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab0EKSZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586Ab0EKSZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:25:07 -0400
Message-ID: <4BE9A100.1060207@redhat.com>
Date: Tue, 11 May 2010 21:25:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zamsden@redhat.com
Subject: Re: [PATCH 0/9] pvclock misc fixes - v4.
References: <1273594667-17175-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1273594667-17175-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 07:17 PM, Glauber Costa wrote:
> This is the fourth version ov kvmclock fixes.
>
> Just two minor changes in patch 5, per avi request, and
> the addition of cpuid.txt file, documenting all cpuid flags
> we use.
>    

Looks good.

> As a side effect, this patch removes the time-travel feature
> in kvm guests.
>    

Too many reports of users accidentally killing their grandparents anyway.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


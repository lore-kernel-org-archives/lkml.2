Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1HJJRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:17:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64360 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab1HJJRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:17:41 -0400
Message-ID: <4E424CAF.1090207@kernel.org>
Date: Wed, 10 Aug 2011 12:17:35 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        levinsasha928@gmail.com, penberg@kernel.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tools/kvm] kvm tools: Use correct size for VESA memory BAR
References: <tip-c6062b72dd6b451c36fb99a450a9bb9a27c0c36b@git.kernel.org>
In-Reply-To: <tip-c6062b72dd6b451c36fb99a450a9bb9a27c0c36b@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/11 11:31 AM, tip-bot for Sasha Levin wrote:
> Commit-ID:  c6062b72dd6b451c36fb99a450a9bb9a27c0c36b
> Gitweb:     http://git.kernel.org/tip/c6062b72dd6b451c36fb99a450a9bb9a27c0c36b
> Author:     Sasha Levin<levinsasha928@gmail.com>
> AuthorDate: Tue, 9 Aug 2011 18:21:02 +0300
> Committer:  Pekka Enberg<penberg@kernel.org>
> CommitDate: Tue, 9 Aug 2011 18:36:31 +0300
>
> kvm tools: Use correct size for VESA memory BAR
>
> This patch makes BAR 1 16k, instead of BAR0 - which is the PIO bar.
>
> Signed-off-by: Sasha Levin<levinsasha928@gmail.com>
> Signed-off-by: Pekka Enberg<penberg@kernel.org>
>

I nuked this with "git push -f" pretty much immediately so the commit is 
not in my tree. Sorry about that.

                         Pekka

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1LKOFY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 09:05:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1LKOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 09:05:23 -0500
Message-ID: <4EE4B890.20500@redhat.com>
Date: Sun, 11 Dec 2011 16:05:04 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: Re: [PATCHv3 00/10] KVM in-guest performance monitoring
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
In-Reply-To: <1320929850-10480-1-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 02:57 PM, Gleb Natapov wrote:
> This patchset exposes an emulated version 2 architectural performance
> monitoring unit to KVM guests.  The PMU is emulated using perf_events,
> so the host kernel can multiplex host-wide, host-user, and the
> guest on available resources.
>
> The patches are against next branch on kvm.git.
>
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1LZMjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 07:39:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab1LZMj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 07:39:27 -0500
Message-ID: <4EF86AD4.6020200@redhat.com>
Date: Mon, 26 Dec 2011 14:38:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: mtosatti@redhat.com, Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: Re: [PATCH] KVM: x86: Fix build breakage due to anonymous field initialization
References: <1319993624-20247-1-git-send-email-gleb@redhat.com> <1319993624-20247-3-git-send-email-gleb@redhat.com> <4EE9E234.6050702@siemens.com>
In-Reply-To: <4EE9E234.6050702@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 02:04 PM, Jan Kiszka wrote:
> Not all compilers accept anonymous field initialization, e.g. gcc
> 4.5.1.
>

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function


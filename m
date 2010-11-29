Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0K2QLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:11:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0K2QLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:11:04 -0500
Message-ID: <4CF3D093.40604@redhat.com>
Date: Mon, 29 Nov 2010 18:10:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode
References: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 05:38 PM, Joerg Roedel wrote:
> Hi Avi, Hi Marcelo,
>
> this patch-set introduces a generic notion of guest-mode for VCPUs in
> KVM. This is already useful as seen in patch 3/3. Nested-VMX also has a
> guest-mode, so it will make sense for this code too.
>

Looks good, apart from the trivial comments on patch 1.

-- 
error compiling committee.c: too many arguments to function


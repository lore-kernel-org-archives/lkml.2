Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0LHKf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:35:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0LHKf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:35:56 -0500
Message-ID: <4CFF5F87.6020502@redhat.com>
Date: Wed, 08 Dec 2010 12:35:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: Add xsetbv intercept
References: <20101207161211.GD13125@amd.com> <1291738506-16278-2-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1291738506-16278-2-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 06:15 PM, Joerg Roedel wrote:
> This patch implements the xsetbv intercept to the AMD part
> of KVM. This makes AVX usable in a save way for the guest on
> AVX capable AMD hardware.
> The patch is tested by using AVX in the guest and host in
> parallel and checking for data corruption. I also used the
> KVM xsave unit-tests and they all pass.
>

Applied both, thanks.

-- 
error compiling committee.c: too many arguments to function


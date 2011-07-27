Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1G0LTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:19:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab1G0LTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:19:43 -0400
Message-ID: <4E2FF443.3070104@redhat.com>
Date: Wed, 27 Jul 2011 14:19:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH -next] kvm: fix TASK_DELAY_ACCT kconfig warning
References: <20110725162542.39ea8d8cbd51604523635c1a@canb.auug.org.au> <20110725110109.b06fe691.rdunlap@xenotime.net>
In-Reply-To: <20110725110109.b06fe691.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 09:01 PM, Randy Dunlap wrote:
> From: Randy Dunlap<rdunlap@xenotime.net>
>
> Fix kconfig dependency warning:
>
> warning: (KVM) selects TASK_DELAY_ACCT which has unmet direct dependencies (TASKSTATS)

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function


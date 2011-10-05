Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785Ab1JENtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 09:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934271Ab1JENtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 09:49:17 -0400
Message-ID: <4E8C604A.5090606@redhat.com>
Date: Wed, 05 Oct 2011 15:48:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joerg.roedel@amd.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH v2 0/9] perf support for x86 guest/host-only bits
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
In-Reply-To: <1317816084-18026-1-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 02:01 PM, Gleb Natapov wrote:
> This patch series consists of Joerg series named "perf support for amd
> guest/host-only bits v2" [1] rebased to 3.1.0-rc7 and in addition,
> support for intel cpus for the same functionality.
>

Looks good to me.  Peter, Ingo, if it works for you as well, please 
merge 1-6 into a branch on tip that I can pull and apply the rest on top of.

-- 
error compiling committee.c: too many arguments to function


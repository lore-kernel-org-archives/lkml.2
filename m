Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1JKJST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:18:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab1JKJSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:18:15 -0400
Message-ID: <4E9409D3.5090507@redhat.com>
Date: Tue, 11 Oct 2011 11:18:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix include dependency for mmu_notifier
References: <1318261575-24256-1-git-send-email-emunson@mgebm.net>
In-Reply-To: <1318261575-24256-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 05:46 PM, Eric B Munson wrote:
> The kvm_host struct can include an mmu_notifier struct but mmu_notifier.h is
> not included directly.

Thanks, applied.  Is there a .config which causes this?

-- 
error compiling committee.c: too many arguments to function


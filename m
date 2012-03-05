Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab2CESLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:11:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318Ab2CESLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:11:00 -0500
Message-ID: <4F5501B3.6050601@suse.de>
Date: Mon, 05 Mar 2012 19:10:59 +0100
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ben Collins <bcollins@ubuntu.com>
Cc: kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: check error return of kvmppc_core_vcpu_create
 first
References: <50A8F108-8055-4115-B4EB-706D97736E65@ubuntu.com>
In-Reply-To: <50A8F108-8055-4115-B4EB-706D97736E65@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 05:30 AM, Ben Collins wrote:
> The result of kvmppc_core_vcpu_create() was being manipulated before it was checked for IS_ERR(). Did not see the bug occur, but caught it when looking through the code.

Nice catch, but this has already been fixed by Matt:

commit c6f3830e7313eea47b526b597aadc5b18c69ad55
Author: Matt Evans <matt@ozlabs.org>
Date:   Tue Dec 6 21:19:42 2011 +0000

     KVM: PPC: Fix vcpu_create dereference before validity check.

     Fix usage of vcpu struct before check that it's actually valid.

     Signed-off-by: Matt Evans <matt@ozlabs.org>
     Signed-off-by: Alexander Graf <agraf@suse.de>


Thanks a lot for sending the patch nevertheless!

Alex


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1CJJHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:07:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab1CJJHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:07:51 -0500
Message-ID: <4D7894E0.7070300@redhat.com>
Date: Thu, 10 Mar 2011 11:07:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: Zachary Amsden <zamsden@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCHv2] fix regression caused by	e48672fa25e879f7ae21785c7efd187738139593
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com> <20110309193003.GB1762@pcnci.linuxbox.cz> <4D77F149.8020906@redhat.com> <20110309223651.GC1762@pcnci.linuxbox.cz>
In-Reply-To: <20110309223651.GC1762@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 12:36 AM, Nikola Ciprich wrote:
> commit 387b9f97750444728962b236987fbe8ee8cc4f8c moved kvm_request_guest_time_update(vcpu),
> breaking 32bit SMP guests using kvm-clock. Fix this by moving (new) clock update function
> to proper place.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function


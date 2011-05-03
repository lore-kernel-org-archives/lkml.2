Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab1ECNUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab1ECNUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:20:36 -0400
Message-ID: <4DC00119.5080807@redhat.com>
Date: Tue, 03 May 2011 16:20:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110421 Fedora/3.1.9-2.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: make guest mode entry to be rcu quiescent state
References: <1303984323-3203-1-git-send-email-gleb@redhat.com> <1303984323-3203-3-git-send-email-gleb@redhat.com> <20110503131317.GA4244@amt.cnet>
In-Reply-To: <20110503131317.GA4244@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 04:13 PM, Marcelo Tosatti wrote:
> Please have it in x86's vcpu_enter_guest, then its more explicit
> (uncertain about the context of kvm_guest_enter call in other arches).

We do need it for other archs, don't we?


-- 
error compiling committee.c: too many arguments to function


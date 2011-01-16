Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1APPSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:18:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1APPSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:18:38 -0500
Message-ID: <4D330C40.4020604@redhat.com>
Date: Sun, 16 Jan 2011 17:18:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: Re: [RFC -v5 PATCH 3/4] export pid symbols needed for kvm_vcpu_on_spin
References: <20110114030209.53765a0a@annuminas.surriel.com> <20110114030450.07b28e2f@annuminas.surriel.com>
In-Reply-To: <20110114030450.07b28e2f@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 10:04 AM, Rik van Riel wrote:
> Export the symbols required for a race-free kvm_vcpu_on_spin.
>

Needs to be reordered with the first patch for bisectability.

-- 
error compiling committee.c: too many arguments to function


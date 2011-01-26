Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1AZPUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:20:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab1AZPUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:20:40 -0500
Message-ID: <4D403BAE.70908@redhat.com>
Date: Wed, 26 Jan 2011 10:20:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [RFC -v6 PATCH 7/8] kvm: keep track of which task is running
 a KVM vcpu
References: <20110120163127.2568f4fe@annuminas.surriel.com> <20110120163632.021c3f37@annuminas.surriel.com> <4D401B39.4040109@redhat.com>
In-Reply-To: <4D401B39.4040109@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 08:01 AM, Avi Kivity wrote:

> Suggest moving the code to vcpu_load(), where it can execute under the
> protection of vcpu->mutex.

I've made the suggested changes by you and Peter, and
will re-post the patch series in a bit...

-- 
All rights reversed

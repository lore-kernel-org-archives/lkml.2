Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1BAOfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:35:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab1BAOfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:35:03 -0500
Message-ID: <4D481A04.5060108@redhat.com>
Date: Tue, 01 Feb 2011 09:34:44 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH -v8 0/7] directed yield for Pause Loop Exiting
References: <20110131164049.0ad68e72@annuminas.surriel.com> <1296557633.26581.101.camel@laptop>
In-Reply-To: <1296557633.26581.101.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 05:53 AM, Peter Zijlstra wrote:
> On Mon, 2011-01-31 at 16:40 -0500, Rik van Riel wrote:
>>
>> v8:
>> - some more changes and cleanups suggested by Peter
>
> Did you, by accident, send out the -v7 patches again? I don't think I've
> spotted a difference..

Arghhh.  Yeah, I did :(

-- 
All rights reversed

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1ADOSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:18:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1ADOSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:18:12 -0500
Message-ID: <4D232C20.80306@redhat.com>
Date: Tue, 04 Jan 2011 09:18:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Zhai, Edwin" <edwin.zhai@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] increase ple_gap default to 64
References: <20110103101907.2926ecca@annuminas.surriel.com> <4D229221.8070305@intel.com>
In-Reply-To: <4D229221.8070305@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 10:21 PM, Zhai, Edwin wrote:
> Riel,
> Thanks for your patch. I have changed the ple_gap to 128 on xen side,
> but forget the patch for KVM:(
>
> A little bit big is no harm, but more perf data is better.

So should I resend the patch with the ple_gap default
changed to 128, or are you willing to ack the current
patch?

-- 
All rights reversed

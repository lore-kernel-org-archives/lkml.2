Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1JDJWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 05:22:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab1JDJWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 05:22:22 -0400
Message-ID: <4E8AD021.1030602@redhat.com>
Date: Tue, 04 Oct 2011 11:21:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joerg.roedel@amd.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 6/9] perf, intel: Use GO/HO bits in perf-ctr
References: <1317649795-18259-1-git-send-email-gleb@redhat.com> <1317649795-18259-7-git-send-email-gleb@redhat.com> <4E89CF73.4020208@redhat.com> <20111003154113.GB3225@redhat.com>
In-Reply-To: <20111003154113.GB3225@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2011 05:41 PM, Gleb Natapov wrote:
> >  Would be better to calculate these when the host msrs are
> >  calculated, instead of here, every vmentry.
> >
> For arch PMU v2 and greater it is precalculated. For v1 (which is almost
> non existent, even my oldest cpu with VMX has v2 PMU) I am not sure it
> will help since we need to copy information to perf_guest_switch_msr
> array anyway here.
>

Okay.

-- 
error compiling committee.c: too many arguments to function


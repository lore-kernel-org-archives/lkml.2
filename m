Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2C1HVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:21:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50689 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2C1HVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:21:08 -0400
Message-ID: <4F72BBCE.1060307@zytor.com>
Date: Wed, 28 Mar 2012 00:20:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Josh Boyer <jwboyer@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] floppy: revert floppy disable halt warning
References: <20120311093853.04f049c2@s6510.linuxnetplumber.net> <20120327162633.654c8d7e.akpm@linux-foundation.org> <CA+5PVA4KsG0CEs8MhEL2qQoLBU9M6xAoPX2qnTZJ2R5RQ7-osg@mail.gmail.com> <20120328064008.GA12735@gmail.com>
In-Reply-To: <20120328064008.GA12735@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 11:40 PM, Ingo Molnar wrote:
> 
> No objections from me.
> 
> Please resubmit against latest -tip, we unified the idle 
> routines which likely interacts with that patch.
> 

To the best of my knowledge, no-hlt only existed because of flaky power
distributions on 386/486 systems which were sold to run DOS.  Since DOS
did no power management of any kind, including HLT, the power draw was
fairly uniform; when exposed to the much higher noise levels you got
when Linux used HLT caused some of these systems to fail.

They were by far in the minority even back then.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


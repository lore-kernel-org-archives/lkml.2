Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1DEG4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 02:56:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37284 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1DEG4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 02:56:07 -0400
Message-ID: <4D9ABCED.30606@zytor.com>
Date: Mon, 04 Apr 2011 23:55:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-1.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <201104050829.58474.rjw@sisk.pl> <4D9AB8B7.9020708@zytor.com> <201104050843.39246.rjw@sisk.pl>
In-Reply-To: <201104050843.39246.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 11:43 PM, Rafael J. Wysocki wrote:
>>
>> Just to refresh my memory... is this an issue in mainline, or is it only
>> a problem in the backport (I'm wondering if the trampoline unification
>> patches might have accidentally solved the issue)?
> 
> The problem is in mainline too, please fix ASAP.

Thanks for confirming, will look at it in the morning.  Just looking for
the sanest place to put the save/restore (it really should be done at
the same places where we save/restore MISC_ENABLE.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


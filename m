Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1DATg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:36:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56351 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab1DATg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:36:58 -0400
Message-ID: <4D96294B.5050909@zytor.com>
Date: Fri, 01 Apr 2011 12:36:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop> <4D95F80D.7070201@kernel.org> <4D95FBDD.9050901@zytor.com> <alpine.DEB.2.00.1104011729000.16492@kaball-desktop> <4D961FBC.2030105@zytor.com> <4D962837.2070300@kernel.org>
In-Reply-To: <4D962837.2070300@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 12:32 PM, Yinghai Lu wrote:
> 
> So for 32 bit, PAE support is not compiled in for old 486 cpus.
> mmu_cr4_feautres will be used to make sure head_32.S will not access cr4.
> 
> that could be the reason why 32 bit does not do read back at beginning.
> 

Yes, but that doesn't explain why we shouldn't set new bits like NX and
PSE in this register.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab1DASPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:15:15 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:60080 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab1DASPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:15:13 -0400
X-IronPort-AV: E=Sophos;i="4.63,283,1299456000"; 
   d="scan'208";a="5102036"
Date: Fri, 1 Apr 2011 19:15:51 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
In-Reply-To: <4D9607E8.2040500@kernel.org>
Message-ID: <alpine.DEB.2.00.1104011915090.16492@kaball-desktop>
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop>
 <4D95F80D.7070201@kernel.org> <4D95FBDD.9050901@zytor.com> <4D9607E8.2040500@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, Yinghai Lu wrote:
> Peter, this patch just restoring old sequence. If you think 32 bit should do same thing, we can do that in another patch.

indeed


> Also after closing looking, Stefano's v1 patch should be ok too.
> because init_memory_mapping is using set_in_cr4(...) and it will update mmu_cr4_features at the same time.

both patches are fine by me

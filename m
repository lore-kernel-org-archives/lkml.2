Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1EXMpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:45:05 -0400
Received: from mxvs2.esa.t-systems.com ([81.7.202.143]:20758 "EHLO
	mxvs2.esa.t-systems.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296Ab1EXMpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:45:04 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 08:45:03 EDT
Date: Tue, 24 May 2011 13:35:02 +0100 (BST)
From: Frank Hofmann <frank.hofmann@tomtom.com>
Reply-To: frank.hofmann@tomtom.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Frank Hofmann <frank.hofmann@tomtom.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/3] Hibernate cleanups
In-Reply-To: <201105211408.28671.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1105241334080.10891@localhost6.localdomain6>
References: <201105211408.28671.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-OriginalArrivalTime: 24 May 2011 12:35:00.0633 (UTC) FILETIME=[FF8F0890:01CC1A0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 May 2011, Rafael J. Wysocki wrote:

> Hi,
>
> Following are three hibernate patches I didn't have the time to
> work on before.
>
> [1/3] - Update comments in kernel/power/hibernate.c
> [2/3] - Remove arch_prepare_suspend()
> [3/3] - Update kerneldoc comments in kernel/power/hibernate.c
>
> Since they don't make any functional changes, I don't think it makes sense
> to wait with them for the next merge window, so I'd like to push them
> for 2.6.40 if no one objects.
>
> Thanks,
> Rafael
>
>

Hi Rafael,

thanks, these are helpful !

FrankH.

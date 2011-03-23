Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab1CWLYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:24:42 -0400
Received: from service87.mimecast.com ([94.185.240.25]:52905 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932554Ab1CWLYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:24:41 -0400
Subject: Re: [PATCH] kmemleak: build kmemleak-test.c as a module-only
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org, mingo@elte.hu,
        fweisbec@gmail.com, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
In-Reply-To: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
References: <1300299394-20844-1-git-send-email-dbaluta@ixiacom.com>
Organization: ARM Limited
Date: Wed, 23 Mar 2011 11:24:29 +0000
Message-ID: <1300879469.23962.40.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 23 Mar 2011 11:24:33.0470 (UTC) FILETIME=[E25CA5E0:01CBE94C]
X-MC-Unique: 111032311243612301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 18:16 +0000, Daniel Baluta wrote:
> mm/kmemleak-test.c is used to provide an example of how kmemleak
> tool works.
> 
> Memory is leaked at module unload-time, so building the test
> in kernel (Y) makes the leaks impossible and the test useless.
> 
> Qualify DEBUG_KMEMLEAK_TEST config symbol with "depends on m",
> to restrict module-only building.
> 
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>

Sorry for the delay.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>



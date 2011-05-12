Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1ELBQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab1ELBQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:16:32 -0400
Subject: Re: [PATCH] arch/c6x: new architecture port for linux
From: Mark Salter <msalter@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110511180711.6be689bd.rdunlap@xenotime.net>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
	 <20110511143442.7c163a74.rdunlap@xenotime.net>
	 <1305161873.15167.78.camel@deneb.localdomain>
	 <20110511180711.6be689bd.rdunlap@xenotime.net>
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Wed, 11 May 2011 21:16:30 -0400
Message-Id: <1305162990.15167.82.camel@deneb.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 18:07 -0700, Randy Dunlap wrote:
> There was one in drivers/platform/c6x/ where a driver included asm/timer.h
> instead of linux/timer.h (IIRC - I don't have the patch handy ATM to run it
> again).  checkpatch said to use linux/ instead of asm/.

Ah, okay. Yeah, that's in a few places actually. Generally speaking,
there is no asm/timer.h and linux/timer.h doesn't include it. Maybe I
should just rename it or make it mach/timer.h which is probably more
appropriate anyway.

--Mark



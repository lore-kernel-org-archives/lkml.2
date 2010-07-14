Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0GNJmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:42:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46339 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab0GNJmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:42:42 -0400
Subject: Re: [PATCH] introduce a default off mode for kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100713215528.GB25784@redhat.com>
References: <20100713215528.GB25784@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 14 Jul 2010 10:42:22 +0100
Message-ID: <1279100542.8592.49.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2010 09:42:22.0817 (UTC) FILETIME=[DC1C3D10:01CB2338]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 22:55 +0100, Jason Baron wrote:
> Introduce a new DEBUG_KMEMLEAK_DEFAULT_OFF config parameter that allows
> kmemleak to be disabled by default, but enabled on the command line
> via: kmemleak=on. Although a reboot is required to turn it on, its still
> useful to not require a re-compile.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>

Thanks, it looks fine to me. I'll merge it in my tree and send Linus a
pull request during the merging window (unless you prefer to push it
yourself, in which case I ack it).

-- 
Catalin


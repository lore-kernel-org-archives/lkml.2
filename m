Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1DRKmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 06:42:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50510 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab1DRKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 06:42:30 -0400
Date: Mon, 18 Apr 2011 11:42:26 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Jamie Iles <jamie@jamieiles.com>, olofj@chromium.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix infinite loop in ARM user perf_event backtrace code
Message-ID: <20110418104226.GA2820@pulham.picochip.com>
References: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 15, 2011 at 08:27:25PM -0700, Sonny Rao wrote:
> The ARM user backtrace code can get into an infinite loop if it
> runs into an invalid stack frame which points back to itself.
> This situation has been observed in practice.  Fix it by capping
> the number of entries in the backtrace.  This is also what other
> architectures do in their backtrace code.

Tested on my v6k board and looks good.

> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

Acked-by: Jamie Iles <jamie@jamieiles.com>

Jamie

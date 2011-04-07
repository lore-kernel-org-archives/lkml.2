Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1DGRI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:08:56 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:59847 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756237Ab1DGRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:08:54 -0400
From: Kevin Hilman <khilman@ti.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@suse.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH/RFC 4/6] ARM: move SH-mobile runtime PM to arm/common for sharing with other platforms
Organization: Texas Instruments, Inc.
References: <1302134569-22825-1-git-send-email-khilman@ti.com>
	<1302134569-22825-5-git-send-email-khilman@ti.com>
	<20110407165654.GD8052@linux-sh.org>
Date: Thu, 07 Apr 2011 10:08:41 -0700
In-Reply-To: <20110407165654.GD8052@linux-sh.org> (Paul Mundt's message of
	"Fri, 8 Apr 2011 01:56:54 +0900")
Message-ID: <8739lu9eg6.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt <lethal@linux-sh.org> writes:

> On Wed, Apr 06, 2011 at 05:02:47PM -0700, Kevin Hilman wrote:
>> There is really nothing SH-mobile specific about this runtime PM
>> implementation.  Any platform wanting to implement runtime PM based on
>> simple clock gating can use this implementation.
>> 
>> Signed-off-by: Kevin Hilman <khilman@ti.com>
>
> This observation is wholly architecture agnostic, so it's not clear that
> keeping it in arch/arm/common is any better. It seems that this would be
> better suited for drivers/base/power/ with a generic Kconfig symbol.

Sounds fine to me.

Thanks for the review,

Kevin

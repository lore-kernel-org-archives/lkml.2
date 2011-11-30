Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1K3VHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:07:10 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56124 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1K3VHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:07:08 -0500
MIME-Version: 1.0
In-Reply-To: <1322686997.29041.11.camel@pasglop>
References: <1322550101-28520-1-git-send-email-tinamdar@apm.com>
	<1322686997.29041.11.camel@pasglop>
Date: Wed, 30 Nov 2011 16:07:08 -0500
Message-ID: <CA+5PVA6773ff0UUjwCqWRS1ytrhAJ=FLOaUFBs4A3TortGOBhg@mail.gmail.com>
Subject: Re: [PATCH v2] powerpc/40x: Add APM8018X SOC support
From: Josh Boyer <jwboyer@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 4:03 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Tue, 2011-11-29 at 12:31 +0530, Tanmay Inamdar wrote:
>> The AppliedMicro APM8018X embedded processor targets embedded applications that
>> require low power and a small footprint. It features a PowerPC 405 processor
>> core built in a 65nm low-power CMOS process with a five-stage pipeline executing
>> up to one instruction per cycle. The family has 128-kbytes of on-chip memory,
>> a 128-bit local bus and on-chip DDR2 SDRAM controller with 16-bit interface.
>
> Thanks, looks much better.

Yes, agreed.  So much better I already sent it to Ben in a pull request.

josh

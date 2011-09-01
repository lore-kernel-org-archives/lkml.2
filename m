Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1IAMCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:02:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37303 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IAMCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <1314844576.26340.10.camel@rui>
References: <1314844576.26340.10.camel@rui>
Date: Thu, 1 Sep 2011 08:02:06 -0400
Message-ID: <CA+5PVA4SUKbcyPx3iBLtYN6adp2CVYrd7Cv8vJFcz5JFAvTTKw@mail.gmail.com>
Subject: Re: [PATCH] EFI: Revert "x86: Serialize EFI time accesses on rtc_lock"
From: Josh Boyer <jwboyer@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: jbeulich@novell.com, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 10:36 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> My kernel freezes during boot with the following log.
> I'm not sure what the problem is, but reverting
> ef68c8f87ed13f65df867dddf36c0e185b27b942 does help.

There was an alternative patch already sent to hpa a couple days ago,
but he's been rather busy.

https://lkml.org/lkml/2011/8/30/253

josh

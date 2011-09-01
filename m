Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab1IAMCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:02:20 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33299 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055Ab1IAMCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:02:18 -0400
Subject: Re: [PATCH] EFI: Revert "x86: Serialize EFI time accesses on
 rtc_lock"
From: Matt Fleming <matt@console-pimps.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: jbeulich@novell.com, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1314844576.26340.10.camel@rui>
References: <1314844576.26340.10.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 13:02:15 +0100
Message-ID: <1314878535.8038.32.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 10:36 +0800, Zhang Rui wrote:
> My kernel freezes during boot with the following log.
> I'm not sure what the problem is, but reverting 
> ef68c8f87ed13f65df867dddf36c0e185b27b942 does help.

I already posted a fix for this, https://lkml.org/lkml/2011/8/30/253

-- 
Matt Fleming, Intel Open Source Technology Center


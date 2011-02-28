Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1B1LMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:12:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45117 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1B1LL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:11:59 -0500
Date: Mon, 28 Feb 2011 11:11:56 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com, arnd@arndb.de,
        Kiran Sutariya <kiran.sutariya@einfochips.com>
Subject: Re: [PATCH V4 2/4] ARM: Xilinx: Adding timer support to the platform
Message-ID: <20110228111156.GB8751@pulham.picochip.com>
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com>
 <1298052881-14591-2-git-send-email-john.linn@xilinx.com>
 <a7f0ed14-296f-450d-af78-6771cd7281d1@VA3EHSMHS022.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7f0ed14-296f-450d-af78-6771cd7281d1@VA3EHSMHS022.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 11:14:39AM -0700, John Linn wrote:
> The timer driver supports the Xilinx PS Timer Counter IP.
> 
> Signed-off-by: Kiran Sutariya <kiran.sutariya@einfochips.com>
> Signed-off-by: John Linn <john.linn@xilinx.com>
> ---

Looks nice to me.  It may be worth adding sched_clock() support to get 
better scheduler resolution in the future but that could come as a 
separate patch.

Jamie

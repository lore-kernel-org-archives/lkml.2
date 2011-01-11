Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1AKLYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:24:41 -0500
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:43804 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab1AKLYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:24:39 -0500
Date: Tue, 11 Jan 2011 13:24:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: manjunatha_halli@ti.com
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC V10 3/7] drivers:media:radio: wl128x: FM Driver Common
 sources
Message-ID: <20110111112434.GE2385@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 11, 2011 at 06:31:23AM -0500, manjunatha_halli@ti.com wrote:
> From: Manjunatha Halli <manjunatha_halli@ti.com>
> 
> These are the sources for the common interfaces required by the
> FM V4L2 driver for TI WL127x and WL128x chips.
> 
> These implement the FM channel-8 protocol communication with the
> chip. This makes use of the Shared Transport as its transport.
> 
> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

looks like this is implementing a "proprietary" (by that I mean: for
this driver only) IRQ API. Why aren't you using GENIRQ with threaded
IRQs support ?

Core IRQ Subsystem would handle a lot of stuff for you.

-- 
balbi

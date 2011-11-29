Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1K2JXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:23:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58428 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1K2JXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:23:14 -0500
Date: Tue, 29 Nov 2011 01:23:10 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwlee@mtekvision.com, joel.clark@intel.com
Subject: Re: [PATCH 2/2] Input: tsc2007 - Add a z1_low_threshhold platform
 data parameter
Message-ID: <20111129092310.GB21758@core.coreip.homeip.net>
References: <1322554378-348-1-git-send-email-feng.tang@intel.com>
 <1322554378-348-2-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322554378-348-2-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 04:12:58PM +0800, Feng Tang wrote:
> This originates from a patch in Meego IVI kernel with the name
> 	linux-2.6.37-connext-0027-tsc2007.patch
> There is no author info excepte a line "From  MeeGo <kernel@meego.com>"
> 
> When integrating tsc2007 on Intel IVI platform, there are a lot of noise
> data whose z1 value is around 10 which is not a sane "z1". So add
> a "z1_low_threshhold" to filter those nosie data, to make the device work
> properly.

Sounds like a task for userspace to ignore pressure that is too low. Bonus
points for making it configurable so user can adjust sensitivity.

Thanks.

-- 
Dmitry

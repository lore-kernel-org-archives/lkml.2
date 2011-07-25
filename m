Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab1GYI3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:29:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59577 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYI3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:29:24 -0400
Date: Mon, 25 Jul 2011 01:29:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: djkurtz@chromium.org
Cc: rydberg@euromail.se, chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 8/9 v2] Input: add BTN_TOOL_QUINTTAP for reporting 5
 fingers on touchpad
Message-ID: <20110725082918.GC22937@core.coreip.homeip.net>
References: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
 <1311169146-20066-9-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311169146-20066-9-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 09:39:05PM +0800, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 

Do we know what we want to do with this gesture? Because if not I'd
rather not merge it for now, until there are real users.

Thanks.

-- 
Dmitry

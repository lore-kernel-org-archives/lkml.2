Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab1CIRov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:44:51 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56783 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab1CIRot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:44:49 -0500
Message-ID: <4D77BC8C.8040801@canonical.com>
Date: Wed, 09 Mar 2011 12:44:44 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH] HID: hid-magicmouse: Correct touch orientation direction
References: <1299692337-1547-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1299692337-1547-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 12:38 PM, Henrik Rydberg wrote:
> The magic trackpad and mouse both report touch orientation in opposite
> direction to the bcm5974 driver and what is written in
> Documents/input/multi-touch-protocol.txt. This patch reverts the
> direction, so that all in-kernel devices with this feature behave the
> same way.
> 
> Since no known application has been utilizing this information yet, it
> seems appropriate also for stable.
> 
> Cc: stable@kernel.org
> Cc: Michael Poole <mdpoole@troilus.org>
> Cc: Chase Douglas <chase.douglas@canonical.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Acked-by: Chase Douglas <chase.douglas@canonical.com>

Thanks for fixing this!

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2GNMvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:51:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51984 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2GNMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:51:35 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1342269203.16850@guyane.yi.org>
References: <1342269203.16850@guyane.yi.org>
Date: Sat, 14 Jul 2012 14:51:33 +0200
Message-ID: <CAKMK7uEXmfitBnk_Og+KeM2peL90fdc_CvuWkragKRqghz+KDw@mail.gmail.com>
Subject: Re: 3.5-rc6 fb hw inteldrmfb
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: werner@guyane.yi.org
Cc: linux-kernel@vger.kernel.org, airlied@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 2:33 PM,  <werner@guyane.yi.org> wrote:
> With 3.4-rc5 that computer runs normal.

I've looked a bit at the logfiles and dmesg contains tons of stuff
that I didn't expect to be there and the other's contain tons of
unrelated stuff (e.g. they contain a few days worth of data). So I
couldn't figure out anything with that.
The difference betwen rc5 and rc6 is simply due to the firmware
kicking, but since rc5 dies in a similar fashion (but simply later) I
think the bug has been introduced earlier.

I guess we're down to a bisect, since 3.4-rc5 seems to work for you.
Can you please to that?

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch

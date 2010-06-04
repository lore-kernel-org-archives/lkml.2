Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0FDQL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:11:57 -0400
Received: from csmtp1.one.com ([195.47.247.21]:34725 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab0FDQLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:11:55 -0400
Message-ID: <4C0925C3.5060403@bitmath.org>
Date: Fri, 04 Jun 2010 18:11:47 +0200
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 0/4] input: evdev: Dynamic buffers (rev3)
References: <1275552062-8153-1-git-send-email-rydberg@euromail.se> <20100604065915.GF21239@core.coreip.homeip.net>
In-Reply-To: <20100604065915.GF21239@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Henrik,
[...]
> 
> I think the patchet moves things in the right direction, however I am
> unsure at the moment about buflock implementation. Any chance you coudl
> redo the series without the buflock (with readers taking dev->event_lock
> for now) and once buflock is sorted we can switch to is as a followup).
> 
> Thanks.
> 

Good idea, I will do that.

Thanks,
Henrik


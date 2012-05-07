Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2EGNSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:18:42 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:57867 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753449Ab2EGNSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:18:40 -0400
Message-ID: <1336396716.7118.2.camel@pldmachine>
Subject: Re: [PATCH] HID: wacom: Add LED selector control for Wacom Intuos4
 WL
From: Przemo Firszt <przemo@firszt.eu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: pinglinux@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Date: Mon, 07 May 2012 14:18:36 +0100
In-Reply-To: <alpine.LNX.2.00.1205071508280.26736@pobox.suse.cz>
References: <1336395218-6865-1-git-send-email-przemo@firszt.eu>
	 <alpine.LNX.2.00.1205071508280.26736@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.0.1 PLD Linux 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2012-05-07, pon o godzinie 15:09 +0200, Jiri Kosina pisze:
> On Mon, 7 May 2012, Przemo Firszt wrote:
[..]
> Przemo,
> 
> is there a particular reason for not using LEDS_CLASS for this, please?
Hi Jiri,
No, I just used the same approach as wacom USB driver. I'll change that.
Thanks!
-- 
Przemo Firszt <przemo@firszt.eu>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab1KCPDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 11:03:21 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:34151 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab1KCPDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 11:03:20 -0400
Message-ID: <4EB2AD70.7060607@ladisch.de>
Date: Thu, 03 Nov 2011 16:04:16 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Timo Jyrinki <timo.jyrinki@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Simultaneous cat and external keyboard input causing kernel panic
References: <CAJtFfxmovJHspHHKbvBVc4pw+u5mjGmUejCXEzdV+GqE=jVSOQ@mail.gmail.com>
In-Reply-To: <CAJtFfxmovJHspHHKbvBVc4pw+u5mjGmUejCXEzdV+GqE=jVSOQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timo Jyrinki wrote:
> Then suddenly the cat shifted his position and there was a kernel panic

Your cat wanted to find out what the magic in "magic SysRq key" means
and pressed Alt+SysRq+C.  The problem is that he did not consult
Documentation/sysrq.txt first; the "C" does _not_ stand for "catnip".


Regards,
Clemens

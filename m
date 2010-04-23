Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0DWBmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:42:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab0DWBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:42:17 -0400
Date: Thu, 22 Apr 2010 18:40:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Anholt <eric@anholt.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel fixes for 2.6.34-rc4
In-Reply-To: <87hbn3kv41.fsf@pollan.anholt.net>
Message-ID: <alpine.LFD.2.00.1004221838140.3739@i5.linux-foundation.org>
References: <87hbn3kv41.fsf@pollan.anholt.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 Apr 2010, Eric Anholt wrote:
>
> I hear you've got an Ironlake laptop. If so, it's time to get excited.
> The interrupt wedging fix is here.

Desktop, not laptop. But yeah, it hasn't locked up _yet_, at least. It 
usually caused a stuck compiz within a minute or two of enabling it.

But sometimes it took longer to get stuck, so who knows. But it's looking 
good so far at least.

		Linus

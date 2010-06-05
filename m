Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab0FEQIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:08:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933617Ab0FEQIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:08:40 -0400
Date: Sat, 5 Jun 2010 09:03:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Anholt <eric@anholt.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm-intel changes for 2.6.35-rc1
In-Reply-To: <871vcqihj2.fsf@pollan.anholt.net>
Message-ID: <alpine.LFD.2.00.1006050902160.3593@i5.linux-foundation.org>
References: <871vcqihj2.fsf@pollan.anholt.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric - I want to do an -rc2 later today, and the current intel graphics 
code has the known problems with cursors not changing right. Can you send 
me the patch/pull request so that we can get that particular regression 
fixed before I release -rc2?

		Linus

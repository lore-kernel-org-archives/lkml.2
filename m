Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031Ab0JHVDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:03:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:38186 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914Ab0JHVDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:03:53 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Re: Linux 2.6.36-rc7
Date: Fri, 8 Oct 2010 23:03:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: John Stoffel <john@stoffel.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <19631.15310.568446.991954@quad.stoffel.home> <201010081717.25940.tvrtko.ursulin@sophos.com>
In-Reply-To: <201010081717.25940.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010082303.17706.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 October 2010 18:17:25 Tvrtko Ursulin wrote:
> Doesn't really solve ordering inside groups so maybe we do not need
> priorities at all just these three classes?

Applications can easily make the priority they register with configurable (and 
default to something in their "range" if we define such ranges).  Wouldn't 
this be enough?

Andreas

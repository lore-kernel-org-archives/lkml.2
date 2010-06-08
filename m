Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab0FHUJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 16:09:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab0FHUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 16:09:00 -0400
Date: Tue, 8 Jun 2010 13:08:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UBI changes for 2.6.35-rc3
In-Reply-To: <20100608084752.11914.19793.sendpatchset@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1006081307450.4506@i5.linux-foundation.org>
References: <20100608084752.11914.19793.sendpatchset@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Artem Bityutskiy wrote:
> 
> please, pull few UBI changes which fix corrupted empty flash
> handling:

I'm currently not pulling stuff that isn't regression fixes (or major 
things like security issues and oopses).

		Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0FAQGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:06:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756790Ab0FAQGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:06:50 -0400
Date: Tue, 1 Jun 2010 09:02:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.35-rc1, patch] fix cpu_chain section mismatch...
In-Reply-To: <alpine.LFD.2.00.1006010842350.3637@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006010901550.3637@i5.linux-foundation.org>
References: <AANLkTilnTVvZOw-bIpcKS0VwhlpYWnnxvOevNv67hnga@mail.gmail.com> <alpine.LFD.2.00.1006010842350.3637@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Linus Torvalds wrote:
> 
> Does anybody have strong preferences (patch appended for reference)?

Never mind. I'll just apply the patch. If somebody _does_ have strong 
preferences, holler with a new patch that updates it to inline or 
whatever..

		Linus

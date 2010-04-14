Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab0DNUr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 16:47:29 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:57023 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0DNUr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 16:47:28 -0400
Date: Wed, 14 Apr 2010 16:47:10 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tobias <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc4
In-reply-to: <alpine.LFD.2.00.1004140733310.15116@i5.linux-foundation.org>
Message-id: <alpine.LFD.2.00.1004141645440.3932@localhost.localdomain>
References: <alpine.LFD.2.00.1004121859480.3647@i5.linux-foundation.org>
 <4BC57F10.8080002@plzk.org>
 <alpine.LFD.2.00.1004140733310.15116@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -rc4 does not boot on my MacBook v2.1.

It is likely that this is already bisected
and fixed by the patch here:
https://bugzilla.kernel.org/show_bug.cgi?id=15749

thanks,
Len Brown, Intel Open Source Technology Center

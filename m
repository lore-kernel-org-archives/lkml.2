Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab0FSTol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:44:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40294 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0FSTok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:44:40 -0400
Date: Sat, 19 Jun 2010 21:44:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Export kexec.h
Message-ID: <20100619194435.GP18946@basil.fritz.box>
References: <20100619132235.GA24200@basil.fritz.box>
 <m1y6eau96z.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6eau96z.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a corresponding patch for /sbin/kexec ?

No. This would be mostly for new users.

> What is the reason for wanting to export a currently kernel only header?

I wrote a manpage and realized the system call is unusable
without a header.

-Andi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab1ANRRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:17:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:43278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1ANRRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:17:47 -0500
Subject: Re: Will you make your code buildable?
From: Peter Zijlstra <peterz@infradead.org>
To: piotr@hosowicz.com
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D308308.8090103@example.com>
References: <4D308308.8090103@example.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 Jan 2011 18:17:26 +0100
Message-ID: <1295025446.2274.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 18:08 +0100, Piotr Hosowicz wrote:
> Hello Peter, hello all,
> 
> I CC LKML, because maybe other are uding Peter's code also. I get 
> following code when I merge your code to Linus tree:
> 
> mm/migrate.c: In function ‘unmap_and_move_huge_page’:
> mm/migrate.c:845: error: ‘rcu_locked’ undeclared (first use in this 
> function)
> mm/migrate.c:845: error: (Each undeclared identifier is reported only once
> mm/migrate.c:845: error: for each function it appears in.)
> 
> I didn't manage to repair it by myself. Will you fix it?

Yeah, I'll refresh post 38-rc1.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1HaQ5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:57:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43663 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab1HaQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:57:45 -0400
Date: Wed, 31 Aug 2011 18:57:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] posix-timers: move global timer id management to signal_struct v2
Message-ID: <20110831165743.GC26495@one.firstfloor.org>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314780837.2801.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314780837.2801.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I might miss something, but dont you also need to 
> 
> 	spin_lock_init(&sig->idr_lock);
> 
> Maybe you should try with LOCKDEP on ;)

Yes I should. Fixed thanks.
-Andi

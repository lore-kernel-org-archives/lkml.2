Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1HZX5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:57:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057Ab1HZX5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:57:52 -0400
Date: Fri, 26 Aug 2011 16:57:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Reduce clock calibration time during slave cpu
 startup
Message-Id: <20110826165737.07ac0e44.akpm@linux-foundation.org>
In-Reply-To: <20110826165634.398b0d2e.akpm@linux-foundation.org>
References: <20110727135730.GA17717@sgi.com>
	<20110826165634.398b0d2e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 16:56:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Note: patch assumes that all multi-core x86 processor sockets have the same
> > clock frequency for all cores. AFAIK, this is true & will continue
> > to be true for a long time. Have I overlooked anything???
> 
> Well, Andi thinks this may become untrue relatively soon.  Then what do
> we do?

err, make that davej@firstfloor.org or something.

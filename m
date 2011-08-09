Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1HILWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:22:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:35370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1HILWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:22:11 -0400
Subject: Re: [PATCH 2/2] dentry: move to per-sb LRU locks
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Date: Tue, 09 Aug 2011 13:21:58 +0200
In-Reply-To: <20110809110420.GT3162@dastard>
References: <1312787021-11324-1-git-send-email-david@fromorbit.com>
	 <1312787021-11324-3-git-send-email-david@fromorbit.com>
	 <1312808544.10488.31.camel@twins> <20110809110420.GT3162@dastard>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312888918.22367.74.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 21:04 +1000, Dave Chinner wrote:

> Ok, so how do I it move the lock to the start of the next cache line
> and have the following variables pack tightly against it so they are
> all on the same cache line? 

Anonymous struct ?

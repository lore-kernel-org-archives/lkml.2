Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab1EPKNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:13:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:50447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1EPKNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:13:06 -0400
Subject: Re: [PATCH] Documentation: statistics about nested locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4DD0F614.2040408@gmail.com>
References: <4DD0F614.2040408@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 12:12:56 +0200
Message-ID: <1305540776.2466.4094.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 12:01 +0200, Juri Lelli wrote:
> +The graph below shows the relation between the lock functions and the 
> various
> +hooks therein. 

That smells like the patch has whitespace damage..

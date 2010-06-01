Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0FAB5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:57:23 -0400
Received: from ozlabs.org ([203.10.76.45]:43675 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0FAB5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:57:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Tue, 1 Jun 2010 11:27:11 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org> <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011127.14794.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 05:45:37 am Linus Torvalds wrote:
> 
> basically, we should do the whole module dependency list regardless 
> of whether we can unload modules or not 

Why?

Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0GHOXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:23:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:52414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab0GHOW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:22:56 -0400
Subject: Re: [PATCH] Add trace event for munmap
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: akpm@linux-foundation.org, mingo@redhat.com, hugh.dickins@tiscali.co.uk,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       anton@samba.org
In-Reply-To: <1278597931-26855-1-git-send-email-emunson@mgebm.net>
References: <1278597931-26855-1-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 16:22:35 +0200
Message-ID: <1278598955.1900.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 15:05 +0100, Eric B Munson wrote:
> This patch adds a trace event for munmap which will record the starting
> address of the unmapped area and the length of the umapped area.  This
> event will be used for modeling memory usage.

Does it make sense to couple this with a mmap()/mremap()/brk()
tracepoint?

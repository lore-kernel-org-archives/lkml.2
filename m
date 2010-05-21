Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985Ab0EUQiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:38:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950Ab0EUQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:38:08 -0400
Date: Fri, 21 May 2010 09:35:52 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/2] misc: don't use sig->count
Message-Id: <20100521093552.e4a77963.akpm@linux-foundation.org>
In-Reply-To: <22494.1274436496@redhat.com>
References: <20100323144836.GA10420@redhat.com>
	<22494.1274436496@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 11:08:16 +0100 David Howells <dhowells@redhat.com> wrote:

> Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > According to grep, get_nr_threads() becomes the only user of sig->count.
> 
> Are these two patches going upstream in this window?
> 

Sure, unless there's a reason not to do this?

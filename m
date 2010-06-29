Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0F2L2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:28:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:50762 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0F2L2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:28:04 -0400
Subject: Re: [PATCH] Add munmap events to perf
From: Peter Zijlstra <peterz@infradead.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: mingo@elte.hu, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Anton Blanchard <anton@samba.org>
In-Reply-To: <20100629083323.GA6917@us.ibm.com>
References: <1277748484-23882-1-git-send-email-ebmunson@us.ibm.com>
	 <1277755486.3561.140.camel@laptop>  <20100629083323.GA6917@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 13:27:46 +0200
Message-ID: <1277810866.1868.32.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 09:33 +0100, Eric B Munson wrote:
> On Mon, 28 Jun 2010, Peter Zijlstra wrote:
> 
> > On Mon, 2010-06-28 at 19:08 +0100, Eric B Munson wrote:
> > > This patch adds a new software event for munmaps.  It will allows
> > > users to profile changes to address space.  munmaps will be tracked
> > > with mmaps.
> > 
> > Why?
> > 
> 
> It is going to be used by a tool that will model memory usage over the
> lifetime of a process.

Wouldn't it be better to use some tracepoints for that instead? I want
to keep the sideband data to a minimum required to interpret the sample
data, and you don't need unmap events for that.



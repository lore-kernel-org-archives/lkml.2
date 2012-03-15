Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2COGPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:15:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2COGPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:15:50 -0400
Date: Wed, 14 Mar 2012 23:18:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 1/3] radix-tree: introduce bit-optimized iterator
Message-Id: <20120314231826.3938e451.akpm@linux-foundation.org>
In-Reply-To: <4F618347.8080400@openvz.org>
References: <20120210191611.5881.12646.stgit@zurg>
	<20120210192542.5881.91143.stgit@zurg>
	<20120314174356.40c35a07.akpm@linux-foundation.org>
	<4F618347.8080400@openvz.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 09:51:03 +0400 Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> > When a c programmer sees a variable called "i", he solidly expects it
> > to have type "int".  Please choose a better name for this guy!
> > Perferably something which helps the reader understand what the
> > variable's role is.
> 
> =) Ok, I can make it "int"

This should be an unsigned type - negative values are meaningless here.

And "i" is simply a poor identifier.  A good identifier is one which
communicates the variable's role.


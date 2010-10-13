Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0JMP6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:58:47 -0400
Received: from canuck.infradead.org ([134.117.69.58]:40797 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0JMP6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:58:45 -0400
Date: Wed, 13 Oct 2010 11:58:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs: Inode cache scalability V3
Message-ID: <20101013155845.GB22447@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <20101013145102.GA12155@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013145102.GA12155@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's 100% reproducible on my kvm VM.  The bug is the assert_spin_locked
in redirty_tail.  I really can't find a way how we reach it without
d_lock so this really confuses me.


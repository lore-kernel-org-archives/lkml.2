Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1EaXHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 19:07:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59603 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab1EaXHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 19:07:07 -0400
Date: Tue, 31 May 2011 16:07:02 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Mark Fasheh <mfasheh@suse.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] ocfs2: use proper little-endian bitops
Message-ID: <20110531230702.GE31742@noexit.corp.google.com>
Mail-Followup-To: Mark Fasheh <mfasheh@suse.com>,
	Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
References: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
 <20110531225713.GA10985@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110531225713.GA10985@wotan.suse.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 03:57:13PM -0700, Mark Fasheh wrote:
> On Mon, May 30, 2011 at 09:58:05PM +0900, Akinobu Mita wrote:
> > Using __test_and_{set,clear}_bit_le() with ignoring its return value
> > can be replaced with __{set,clear}_bit_le().
> > 
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > Cc: Joel Becker <jlbec@evilplan.org>
> > Cc: Mark Fasheh <mfasheh@suse.com>
> > Cc: ocfs2-devel@oss.oracle.com
> 
> Looks reasonable to me...
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.com>
> 
> Joel?

	No argument here.  Akinobu, do you want me to send it with ocfs2
fixes, or are you going to push it along?

Acked-by: Joel Becker <jlbec@evilplan.org>

Joel

-- 

"Lately I've been talking in my sleep.
 Can't imagine what I'd have to say.
 Except my world will be right
 When love comes back my way."

			http://www.jlbec.org/
			jlbec@evilplan.org

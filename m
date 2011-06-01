Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab1FACYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:24:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43237 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab1FACYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:24:47 -0400
Date: Tue, 31 May 2011 19:24:39 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH] ocfs2: use proper little-endian bitops
Message-ID: <20110601022438.GD29741@noexit.corp.google.com>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
	ocfs2-devel@oss.oracle.com
References: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306760285-4364-1-git-send-email-akinobu.mita@gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 09:58:05PM +0900, Akinobu Mita wrote:
> Using __test_and_{set,clear}_bit_le() with ignoring its return value
> can be replaced with __{set,clear}_bit_le().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: ocfs2-devel@oss.oracle.com

This patch is now in the 'fixes' branch of ocfs2.git.

Joel

-- 

"But then she looks me in the eye
 And says, 'We're going to last forever,'
 And man you know I can't begin to doubt it.
 Cause it just feels so good and so free and so right,
 I know we ain't never going to change our minds about it, Hey!
 Here comes my girl."

			http://www.jlbec.org/
			jlbec@evilplan.org

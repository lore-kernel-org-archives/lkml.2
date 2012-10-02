Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab2JBVKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:10:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:53459 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178Ab2JBVKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:10:10 -0400
Date: Tue, 2 Oct 2012 17:10:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Hugh Dickins <hughd@google.com>
Cc: Shuah Khan <shuah.khan@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel NULL pointer dereference at rb_erase+0x1a3/0x370
Message-ID: <20121002211007.GB15277@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Hugh Dickins <hughd@google.com>, Shuah Khan <shuah.khan@hp.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <1349200709.3141.30.camel@lorien2>
 <alpine.LSU.2.00.1210021317030.1700@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1210021317030.1700@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series in question has already been dropped, since there
were some other problems found and we decided it wasn't ready for this
merge window.

If you look at the latest linux-next branch, you'll see that those
patches are gone, so it should be good once you upgrade to the latest
linux-next.

						- Ted

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2JIS0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab2JIS0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:26:32 -0400
Date: Tue, 9 Oct 2012 11:26:25 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 2/5] aio: kiocb_cancel()
Message-ID: <20121009182625.GM26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-2-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349764760-21093-2-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:39:17PM -0700, Kent Overstreet wrote:
> Minor refactoring, to get rid of some duplicated code

Honestly: I wouldn't bother.  Nothing of consequence uses cancel.

I have an RFC patch series that tears it out.  Let me polish that up
send it out, I'll cc: you.

- z

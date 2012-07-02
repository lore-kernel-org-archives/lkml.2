Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2GBIOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271Ab2GBIOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:14:09 -0400
Message-ID: <4FF1584A.6010903@redhat.com>
Date: Mon, 02 Jul 2012 10:14:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Chris Friesen <chris.friesen@genband.com>
Subject: Re: [PATCH v2 1/2] msync: support syncing a small part of the file
References: <1339773179-31210-1-git-send-email-pbonzini@redhat.com> <1339773179-31210-2-git-send-email-pbonzini@redhat.com> <20120622141253.1e9747cf.akpm@linux-foundation.org>
In-Reply-To: <20120622141253.1e9747cf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/06/2012 23:12, Andrew Morton ha scritto:
> Please recall my thus-far-utterly-and-irritatingly-ignored comments
> about nonlinear mappings.  Presently an msync() on a nonlinear mapping
> will work correctly, because we sync the whole file, yes?  And with
> this change, we will no longer sync all the pages which were covered by
> the affected memory range.  Thus breaking the syscall?

The comment was not ignored, it was missed altogether, and you're
completely right.

Paolo

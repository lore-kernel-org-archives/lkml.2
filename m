Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2DJXNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:13:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878Ab2DJXNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:13:20 -0400
Date: Wed, 11 Apr 2012 01:12:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hang opening a pipe written to by a child, with SIGCHLD
Message-ID: <20120410231254.GA18173@redhat.com>
References: <20120409120326.f0ce7a94.akpm@linux-foundation.org> <20120410225516.GA13486@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410225516.GA13486@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11, Oleg Nesterov wrote:
>
> Or may be you can "fix" this script, just add "exec < $PIPE"
> before the main "while true" loop.

Cough, no ;) this can equally race with the exiting child.

Oleg.


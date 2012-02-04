Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2BDAYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:24:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56920 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab2BDAYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:24:41 -0500
Date: Sat, 4 Feb 2012 03:24:35 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.0 does not survive make -j [sic] on a kernel tree
Message-ID: <20120204002435.GA3054@p183.telecom.by>
References: <CALCETrVYSo+5mHjQp54YFrmHXXf0ugj2N4D4aFek-vMvZ5QD9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVYSo+5mHjQp54YFrmHXXf0ugj2N4D4aFek-vMvZ5QD9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 04:18:28PM -0800, Andy Lutomirski wrote:
> make clean ; make -j hangs quickly, 100% reproducibly.  The system
> answers pings but is otherwise completely unresponsive.  The
> softlockup detector output and eventual oom is below.  The system does
> not appear to recover.
> 
> The correct answer is "don't do that".  But this seems like poor behavior.

"make -j" is like fork bomb.
But if you turn on heavy debugging options, system might actually survive
to the completion.

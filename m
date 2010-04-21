Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0DUOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 10:09:26 -0400
Received: from fifo99.com ([67.223.236.141]:37113 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab0DUOJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 10:09:24 -0400
Subject: Re: Please pull logfs tree for fixes
From: Daniel Walker <dwalker@fifo99.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100421121932.GA18441@logfs.org>
References: <20100421121932.GA18441@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 07:09:22 -0700
Message-ID: <1271858963.2058.4.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 14:19 +0200, Jörn Engel wrote:
> Another set of fixes.  Two of them are security relevant.  But given
> that an attacker needs mount access and few people have logfs compiled
> in, that's unlikely to be a huge issue.
> 
>  gc.c        |    8 ++++++
>  journal.c   |   29 ++++++++++++++---------
>  logfs.h     |   15 ++++++++++--
>  readwrite.c |   75 +++++++++++++++++++++++++++++++++---------------------------
>  segment.c   |    8 ------
>  super.c     |   11 +++++++-
>  6 files changed, 91 insertions(+), 55 deletions(-)

Where is the url for your tree? There's a git command,

"git request-pull"

It spits out a form email with url , and all the needed info.

Daniel


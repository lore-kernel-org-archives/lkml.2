Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1JOMB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 08:01:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32775 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1JOMBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 08:01:25 -0400
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: David Rientjes <rientjes@google.com>
Subject: Re: Reporting Kernel Bugs
Date: Sat, 15 Oct 2011 14:01:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc4; KDE/4.6.5; i686; ; )
Cc: Jan Steinke <jan.steinke@gmail.com>, linux-kernel@vger.kernel.org
References: <4E95D7A6.6010603@canonical.com> <loom.20111014T220901-636@post.gmane.org> <alpine.DEB.2.00.1110141321250.24783@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110141321250.24783@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110151401.19977.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On piątek, 14 października 2011 o 22:23:57 David Rientjes wrote:
> On Fri, 14 Oct 2011, Jan Steinke wrote:
> > > Just send an e-mail to appropriate mailinglist and CC
> > > responsible maintainer(s).
> > > 
> > > That's what many people prefer to bugzilla anyway.
> > 
> > How do I know the responsible maintainer(s)? How do I know if the bug is
> > confirmed or accepted?
> 
> If you can figure out what subsystem is the likely source of the issue,
> then you can check the MAINTAINERS file for the appropriate people and
> mailing list.  If there's a panic or oops, find the source file that is to
> blame and use ./scripts/get_maintainer.pl -f <file>.  Otherwise, just
> report some unknown, untriaged error directly to
> linux-kernel@vger.kernel.org and be sure to cc Andrew Morton
> <akpm@linux-foundation.org> who used to go through the kernel.org bugzilla
> quite often and send bug reports in the right direction.

For regression add my address to CC. When bugzilla comes back, then I create 
bug entry for regression.

Regards
-- 
Maciej Rutecki
http://www.mrutecki.pl

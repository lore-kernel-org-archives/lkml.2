Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0CZDQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:16:57 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:53063 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0CZDQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=W5A4EFjEd43TM57DmyumE5KqcByXGIO4TuazbMXk6TR1TDQ3afsjt4LpYUYsIaMniX
         qdgi9bQ7nTMNB463Nxl9EfrEEHEJXsnU+H4Xjh5EepVqcByzsbQVtwO8UmlNz7KC/hYA
         InQ/h0uQ78wHpGZrAtZ16+r19p3EDADE1qEtQ=
Message-ID: <4bac2726.017ee70a.188b.1305@mx.google.com>
Date: Thu, 25 Mar 2010 20:16:54 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
In-Reply-To: <4ba05b07.9f15f10a.5ac5.144f@mx.google.com>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<20100317012439.GA8256@thunk.org>
	<4ba049f1.017ee70a.5ce6.1456@mx.google.com>
	<20100317033010.GE8256@thunk.org>
	<4ba05b07.9f15f10a.5ac5.144f@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 21:31:03 -0700 (PDT), Ben Gamari <bgamari.foss@gmail.com> wrote:
> On Tue, 16 Mar 2010 23:30:10 -0400, tytso@mit.edu wrote:
> > .... so did switching to Btrfs solve your latency issues, or are you
> > still having problems?
> 
> Still having troubles although I'm now running 2.6.34-rc1 and things seem
> mildly better. I'll try doing a backup tonight and report back.
> 
I stand by my assertion that 2.6.34 does seem better in some regards. While
there certainly are still latency issues, it's now less often that heavy I/O
spills over into over processes' interactive performance. That being said,
earlier this evening Tracker and notmuch were both indexing and I saw several
events of tens of seconds of latency.

- Ben

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab0CQEbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:31:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39109 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0CQEbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=bNAqkOGLKbpeFD1E6z82JG4bW8ypfWymIkUfgfY/aV7L7b69GtSojE8A7i1EqEBJGo
         M1j4694HkpXpf7Z+egtBp2vxJl6GnYWKa9Eob0oKtUbOJAiTy8X2rKgl8rFIMa1PVFCn
         sZp0vDjOzJdxJYGQUe4qN+KRuizfT9DOWFLLc=
Message-ID: <4ba05b07.9f15f10a.5ac5.144f@mx.google.com>
Date: Tue, 16 Mar 2010 21:31:03 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
In-Reply-To: <20100317033010.GE8256@thunk.org>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<20100317012439.GA8256@thunk.org>
	<4ba049f1.017ee70a.5ce6.1456@mx.google.com>
	<20100317033010.GE8256@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010 23:30:10 -0400, tytso@mit.edu wrote:
> .... so did switching to Btrfs solve your latency issues, or are you
> still having problems?

Still having troubles although I'm now running 2.6.34-rc1 and things seem
mildly better. I'll try doing a backup tonight and report back.

- Ben

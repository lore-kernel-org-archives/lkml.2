Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab1ASQO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:14:58 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33676 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1ASQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:14:57 -0500
Date: Wed, 19 Jan 2011 17:14:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119161455.GA18503@merkur.ravnborg.org>
References: <20110118201323.GA14930@Krystal> <1295382144.12215.123.camel@gandalf.stny.rr.com> <20110119050844.GA8776@Krystal> <20110118.211639.68142725.davem@davemloft.net> <20110119151004.GA11022@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119151004.GA11022@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If my memory serves me correctly, I think "long long" is aligned on 4 bytes on
> ppc32, but on 8 bytes on x86_32 (yeah, that's weird). How about we create a
> #define __long_long_aligned __attribute__((__aligned__(__alignof__(long long))))

#define __u64_aligned __attribute__((__aligned__(__alignof__(long long))))

A bit shorter but maybe less obvious.

	Sam

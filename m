Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0FYTkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:40:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37837 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab0FYTkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qvwhsBNYqWZWBHVkr0Qm2s/p2Shwmu5Ua8IIUmc+ekyL8UPqi6RXZ1QF3mt7KxRABs
         ybl3G6DHiMutY0EGS7K6yVvqlYcsgHwyViwTUCG/cJAxsX+T6S1J0lO4ZWBvdP8BwNLK
         Sj8Le3XuLcjZGSSm56smRoIfL62Z4epUzgX6Q=
MIME-Version: 1.0
In-Reply-To: <20100625184504.GA11867@infradead.org>
References: <20100624131455.GA10441@laptop> <A57010D3-065B-41B1-85E6-8B9C61970D37@dilger.ca> 
	<20100625040156.GQ10441@laptop> <1A529206-98C4-4A88-A2CA-18522D4D631D@dilger.ca> 
	<AANLkTin__C1EOuTFJJ4UqAFsO5x_IOKLX11boRl7B194@mail.gmail.com> 
	<20100625181638.GA15227@infradead.org> <20100625184504.GA11867@infradead.org>
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 25 Jun 2010 12:40:22 -0700
Message-ID: <AANLkTikicz4WXG2GRuoc9RUZy9AmpYuoi5ifEXO6g2EJ@mail.gmail.com>
Subject: Re: [rfc] new stat*fs-like syscall?
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 11:45, Christoph Hellwig <hch@infradead.org> wrote:
> I don't quite get what ST_WRITE is supposed to mean.  All but that one
> can be supported trivially.

ST_WRITE comes elsewhere.  We don't use it on Linux.


> In addition ST_APPEND and ST_IMMUTABLE are rather puzzling.  Do you
> really want these to mean if the file we call statfs on have the
> immutable/append only bits set?  That is mixing two bits of stat
> information into statfs?

Ignore these as well, they also has a different source.

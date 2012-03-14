Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305Ab2CNKki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 06:40:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55963 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469Ab2CNKkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 06:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120314075842.GA337@infradead.org>
References: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com>
	<20120314075842.GA337@infradead.org>
Date: Wed, 14 Mar 2012 12:40:36 +0200
Message-ID: <CACVxJT-73diTvBhDxZ=7VUz2BqaRetdnCUGk3hh+_7gyWXB6Dw@mail.gmail.com>
Subject: Re: [PATCH] Install kernel-page-flags.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@akkadia.org>, arnd@arndb.de, davem@davemloft.net,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        linux-kernel@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:58 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Mar 14, 2012 at 03:26:07AM -0400, Ulrich Drepper wrote:
>> Programs using /proc/kpageflags need to know about the various flags.  The
>> <linux/kernel-page-flags.h> provides them and the comments in the file
>> indicate that it is supposed to be used by user-level code.  But the file
>> is not installed.
>>
>> The patch below installs the headers and marks the unstable flags as
>> out-of-bounds.
>
> I don't think this is a good idea at all.  Let's shoot the person who
> added that braindead interface ASAP, and replace it with one printing
> the flags in ASCII format.

ASCII sucks.
This interface is not for humans.

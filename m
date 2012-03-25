Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2CYM3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 08:29:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65201 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2CYM3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 08:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <CACVxJT_4Lp3FYjsE_-pW_E3pT-hd5ARF0_2qMMJo5ooT3Y_WfA@mail.gmail.com>
References: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com>
 <20120314075842.GA337@infradead.org> <CACVxJT-73diTvBhDxZ=7VUz2BqaRetdnCUGk3hh+_7gyWXB6Dw@mail.gmail.com>
 <20120319113241.GA13991@infradead.org> <CACVxJT_4Lp3FYjsE_-pW_E3pT-hd5ARF0_2qMMJo5ooT3Y_WfA@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sun, 25 Mar 2012 08:28:50 -0400
Message-ID: <CAOPLpQf2cw=B7TmmrptKu-M8rNwpJqccKaC2qs3d5bdp22mEMg@mail.gmail.com>
Subject: Re: [PATCH] Install kernel-page-flags.h
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ulrich Drepper <drepper@akkadia.org>, arnd@arndb.de,
        davem@davemloft.net, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 08:45, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> I guess the best we can do is to have a translation table for kernel
>> internal to external documented flags.  Once you export the header with
>> the meanings it's time to add that table, even if it starts out as a 1:1
>> mapping.
>
> Well, this is totally different issue.
> Translation is already there, see stable_page_flags().

Considering this, could the patch please be used?  Otherwise you might
as well remove the /proc interfaces.

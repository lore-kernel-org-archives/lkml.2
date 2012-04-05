Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab2DEPx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:53:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44141 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2DEPxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:53:55 -0400
MIME-Version: 1.0
X-Originating-IP: [88.209.222.127]
In-Reply-To: <20120405154118.GA3360@infradead.org>
References: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
	<1333637940-31884-28-git-send-email-miklos@szeredi.hu>
	<20120405154118.GA3360@infradead.org>
Date: Thu, 5 Apr 2012 17:53:54 +0200
Message-ID: <CAJfpeguEDoV7qV0pr4g53-0f-8UVa0bbr8U5ik4bCAxqvm82YA@mail.gmail.com>
Subject: Re: [PATCH 27/34] fuse: implement i_op->atomic_create()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 5:41 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Apr 05, 2012 at 04:58:53PM +0200, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Replace fuse's ->create implementation with a ->atomic_create implementation.
>> No functionality is changed.
>
> atomic_create is atomic_open now.  Same applies for the subject and
> commit log in a couple of the following patches.
>

Thought I fixed those.  Anyway, fixed now.  Thanks.

Miklos

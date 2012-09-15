Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab2IOCHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:07:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43638 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2IOCHo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120915015703.GR13973@ZenIV.linux.org.uk>
References: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
	<20120915015703.GR13973@ZenIV.linux.org.uk>
Date: Fri, 14 Sep 2012 19:07:43 -0700
Message-ID: <CA+cF-pv2gyn+LqUAwyiojmzC=6y+mjqf1KkaV_86jMZaJ0oJtQ@mail.gmail.com>
Subject: Re: Getting debugfs mountpoint?
From: Jacob Sowles <sowlesj@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple instances of my code can be run simultaneously, and all
instances use the same debugfs directory, so I need the path to the
debugfs root directory so that I can use filp_open to get the dentry
for that directory.

Jacob

On Fri, Sep 14, 2012 at 6:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Sep 14, 2012 at 06:49:01PM -0700, Jacob Sowles wrote:
>> Is there an easy way to get the path to where debugfs is mounted? I
>> found a function called debugfs_find_mountpoint(), which is exactly
>> what I want, but it’s not exported, so I can’t use it. The only
>> exported debugfs functions that I could find are the ones that create,
>> remove, etc.
>
> More to the point, it's a userland function.  Why would you want that
> kernel-side?

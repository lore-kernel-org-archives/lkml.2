Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab2IOB5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:57:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2IOB5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:57:05 -0400
Date: Sat, 15 Sep 2012 02:57:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jacob Sowles <sowlesj@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting debugfs mountpoint?
Message-ID: <20120915015703.GR13973@ZenIV.linux.org.uk>
References: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 06:49:01PM -0700, Jacob Sowles wrote:
> Is there an easy way to get the path to where debugfs is mounted? I
> found a function called debugfs_find_mountpoint(), which is exactly
> what I want, but it’s not exported, so I can’t use it. The only
> exported debugfs functions that I could find are the ones that create,
> remove, etc.

More to the point, it's a userland function.  Why would you want that
kernel-side?

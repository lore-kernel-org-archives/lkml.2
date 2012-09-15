Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2IOCLI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:11:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54575 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2IOCLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:11:06 -0400
Date: Sat, 15 Sep 2012 03:11:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jacob Sowles <sowlesj@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting debugfs mountpoint?
Message-ID: <20120915021104.GS13973@ZenIV.linux.org.uk>
References: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
 <20120915015703.GR13973@ZenIV.linux.org.uk>
 <CA+cF-pv2gyn+LqUAwyiojmzC=6y+mjqf1KkaV_86jMZaJ0oJtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+cF-pv2gyn+LqUAwyiojmzC=6y+mjqf1KkaV_86jMZaJ0oJtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 07:07:43PM -0700, Jacob Sowles wrote:
> Multiple instances of my code can be run simultaneously, and all
> instances use the same debugfs directory, so I need the path to the
> debugfs root directory so that I can use filp_open to get the dentry
> for that directory.

What's wrong with just storing a pointer to that dentry in a variable?
And what do you want an opened file (of a directory, at that) on debugfs?

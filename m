Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2IOC1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:27:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45117 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2IOC1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:27:41 -0400
Date: Sat, 15 Sep 2012 03:27:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jacob Sowles <sowlesj@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting debugfs mountpoint?
Message-ID: <20120915022739.GT13973@ZenIV.linux.org.uk>
References: <CA+cF-pv-a37D=a-ugNSWp8=z+y6H04B+eJHhnmBADsTBe1Edrw@mail.gmail.com>
 <20120915015703.GR13973@ZenIV.linux.org.uk>
 <CA+cF-pv2gyn+LqUAwyiojmzC=6y+mjqf1KkaV_86jMZaJ0oJtQ@mail.gmail.com>
 <20120915021104.GS13973@ZenIV.linux.org.uk>
 <CA+cF-pt5_SENuizLXjQOSC4gJ8hMOnc9SamALLU77RWvwFa-sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+cF-pt5_SENuizLXjQOSC4gJ8hMOnc9SamALLU77RWvwFa-sQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 07:17:12PM -0700, Jacob Sowles wrote:
> The first instance of my code calls debugfs_create_file and stores a
> pointer to the dentry of that directory. But when the second instance
> calls debugfs_create_file, the function returns NULL because that
> directory already exists, so it doesn't return the dentry that I need.

... and?  Ever heard of that thing called "global variable"?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2C0Uxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 16:53:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56720 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2C0Ux0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 16:53:26 -0400
Date: Tue, 27 Mar 2012 13:53:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Haifeng <omycle@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: To built-in Driver, When the corresponding node under /dev
 created?
Message-ID: <20120327205320.GA20151@kroah.com>
References: <CAFNq8R5FqEZG1rx54LSv-iAcc9keG-dNKe5fAiEWMBe2sS-nSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFNq8R5FqEZG1rx54LSv-iAcc9keG-dNKe5fAiEWMBe2sS-nSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 02:39:37PM +0800, Li Haifeng wrote:
> As you know, the node under /dev are managed by udevd daemon.

Not always, usually the node is created by devtmpfs on most modern
distros.

> But to the built-in driver module, when the module is probed in kernel
> space, udevd daemon doesn't running. So, to ttyS node, when the
> built-in driver module was probed, when was the /dev/ttyS  created?

devtmpfs does it.

Also, look at your distro startup code, it sets things up properly when
userspace starts up and has udev go through things and set up the nodes
then.

good luck,

greg k-h

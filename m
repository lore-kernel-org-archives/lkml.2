Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab2C1AoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:44:24 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59245 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320Ab2C1AoW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:44:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120327205320.GA20151@kroah.com>
References: <CAFNq8R5FqEZG1rx54LSv-iAcc9keG-dNKe5fAiEWMBe2sS-nSg@mail.gmail.com>
	<20120327205320.GA20151@kroah.com>
Date: Wed, 28 Mar 2012 08:44:21 +0800
Message-ID: <CAFNq8R4C2TyjXF+1=_GEszpem7wQj9syRrhO5T3gisiBw10sSw@mail.gmail.com>
Subject: Re: To built-in Driver, When the corresponding node under /dev created?
From: Li Haifeng <omycle@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

I also found it @ http://lwn.net/Articles/330985/
On Wed, Mar 28, 2012 at 4:53 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Mar 27, 2012 at 02:39:37PM +0800, Li Haifeng wrote:
>> As you know, the node under /dev are managed by udevd daemon.
>
> Not always, usually the node is created by devtmpfs on most modern
> distros.
>
>> But to the built-in driver module, when the module is probed in kernel
>> space, udevd daemon doesn't running. So, to ttyS node, when the
>> built-in driver module was probed, when was the /dev/ttyS  created?
>
> devtmpfs does it.
>
> Also, look at your distro startup code, it sets things up properly when
> userspace starts up and has udev go through things and set up the nodes
> then.
>
> good luck,
>
> greg k-h

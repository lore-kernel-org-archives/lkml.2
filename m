Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2GIWVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:21:32 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53182 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2GIWVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:21:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXN00en27i3F16GL+HJoqVT=DenUWLCg0u4v-7vqcBTcQ@mail.gmail.com>
References: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
 <20120709203208.28178.94320.stgit@bhelgaas.mtv.corp.google.com> <CAE9FiQXN00en27i3F16GL+HJoqVT=DenUWLCg0u4v-7vqcBTcQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Jul 2012 16:21:09 -0600
Message-ID: <CAErSpo7pEh=_QSpdN3Q-vzPY3dkKW0yXuB4FM4SxZ7CnSVn5Gw@mail.gmail.com>
Subject: Re: [PATCH 2/3] PCI: reimplement P2P bridge 1K I/O windows (Intel P64H2)
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, Daniel Yeisley <dan.yeisley@unisys.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 3:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jul 9, 2012 at 1:32 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> Note that the bridge window assignment code, e.g., pbus_size_io(), should
>> pay attention to dev->io_window_1k, too, but I didn't fix that.
>
> Please check attached patch that will fix pbus_size_io.

Thanks for posting this again.  I had looked for it, but couldn't find it.

> You may fold the patch in your patch, or could split your patch to
> two. First one
> only add io_window_1k, and second one will use io_window_1k. Then could put my
> patch between them.

What bad things would happen if I just appended your patch to the end
of this series?  Would that break bisection in some scenario?

Bjorn

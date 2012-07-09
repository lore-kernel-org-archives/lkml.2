Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2GIXuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 19:50:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37722 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2GIXuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 19:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7pEh=_QSpdN3Q-vzPY3dkKW0yXuB4FM4SxZ7CnSVn5Gw@mail.gmail.com>
References: <20120709202308.28178.58942.stgit@bhelgaas.mtv.corp.google.com>
	<20120709203208.28178.94320.stgit@bhelgaas.mtv.corp.google.com>
	<CAE9FiQXN00en27i3F16GL+HJoqVT=DenUWLCg0u4v-7vqcBTcQ@mail.gmail.com>
	<CAErSpo7pEh=_QSpdN3Q-vzPY3dkKW0yXuB4FM4SxZ7CnSVn5Gw@mail.gmail.com>
Date: Mon, 9 Jul 2012 16:50:02 -0700
X-Google-Sender-Auth: sKP1x43EuVGlNwUgclSeA2bI1ZY
Message-ID: <CAE9FiQX7o7obB_dzz3gmMTGijR7MOx1BSmDn+uxmh2wVZsFyfQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] PCI: reimplement P2P bridge 1K I/O windows (Intel P64H2)
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, Daniel Yeisley <dan.yeisley@unisys.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 3:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:

> What bad things would happen if I just appended your patch to the end
> of this series?  Would that break bisection in some scenario?

Should be ok. it should not break bisection.
Don't think sizing is working for 1k before.

Thanks

Yinghai

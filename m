Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2DWUTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:19:13 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49971 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2DWUTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <4F95B17B.3030401@redhat.com>
References: <20120410090306.GA7056@richard>
	<20120422155202.GA13540@richard>
	<4F95B17B.3030401@redhat.com>
Date: Mon, 23 Apr 2012 13:19:11 -0700
X-Google-Sender-Auth: BU5tBCEo1KBfxrZI1LSVH7e-Ntg
Message-ID: <CAE9FiQX52eL6ZFQ_X3uL5DukK03sPhByZpPh0++o6L=WF8BGXg@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 12:46 PM, Don Dutile <ddutile@redhat.com> wrote:
> I have run into a similar problem recently when trying to use
> pci=assign-busses
> with an SRIOV device behind a non-ARI-capable PCIe switch.
> In this scenario, the assign-busses code assigned the next bus number,
> which conflicted with an existing one on the system, and hangs the
> system -- two bridges responding to the same PCI bus num evidently
> confuses the hw! ;-)

can you post boot log and lspci -vvxxx?

Yinghai

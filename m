Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2IESlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:41:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63297 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2IESlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:41:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120905065118.GA9603@localhost>
References: <20120905065118.GA9603@localhost>
Date: Wed, 5 Sep 2012 11:41:04 -0700
X-Google-Sender-Auth: idA5xwhzN1v3OJdWbHZIZ28izAQ
Message-ID: <CAE9FiQVO6dj+rEP=phQD5VYEF-rak6UPYGMSV8ud0OyELo7Opg@mail.gmail.com>
Subject: Re: PCI/e1000 BUG: unable to handle kernel paging request at 0ffff163
From: Yinghai Lu <yinghai@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 11:51 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Yinghai,
>
> There are many kernel paging errors showing up in tree:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-for-each-res-addon-v2
>
> The below summary shows that
>
> 1) it's a reliably reproducible bug
> 2) all paging fault happens at address 0ffff163 and in some e1000 functions
>
> I'll try to bisect if the root cause is not obvious to you.  (Cannot
> do so for now because there are 3 bisections on the way and I cannot
> afford more..)

thanks, will check that...

the 32bit kernel as kvm gust, and host is doing pci passthrough to
export the VF to the KVM guest?

Thanks

Yinghai

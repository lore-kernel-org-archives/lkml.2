Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965900Ab0GPPuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 11:50:25 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:39941 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965842Ab0GPPuX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:50:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=l96EwinJ9h1cHgv2/ErI/X67MAtT3K71hC55kI7EtJlhLq2L02TJdshlCDaGafxx2gmgpG+WRwobsUrPo08zNmESlV46mcr5GGO4evMgrvlXxm2QKXoPoKfY07P7V65d;
Date: Fri, 16 Jul 2010 08:50:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: vgoyal@redhat.com, "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, seto.hidetoshi@jp.fujitsu.com,
        Matt Carlson <mcarlson@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH repost] pci: fix compilation when CONFIG_PCI_MSI=n
Message-ID: <20100716085021.4d521096@virtuousgeek.org>
In-Reply-To: <20100716142050.GA4970@redhat.com>
References: <20100716142050.GA4970@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010 17:20:50 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> vers/pci/pci.c:2277: error: redefinition of ‘pci_msi_off’
> include/linux/pci.h:786: note: previous definition of ‘pci_msi_off’ was here
> 
> No need for ifdef: we must disable the capability at startup even if the
> current kernel does not support MSI, otherwise the device won't work.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Looks like I didn't tag this old patch of mine clearly enough
> so it's still not fixed in -rc5.
> It's late in the cycle, but the patch is trivial
> and it's a build fix, so ... please consider for 2.6.35.

I thought this was supposed to go via the virtualization tree...  But I
can pick it up and try to send to Linus.

-- 
Jesse Barnes, Intel Open Source Technology Center

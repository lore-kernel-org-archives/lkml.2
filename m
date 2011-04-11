Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1DKVHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:07:11 -0400
Received: from kroah.org ([198.145.64.141]:47231 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1DKVHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:07:09 -0400
Date: Mon, 11 Apr 2011 14:02:47 -0700
From: Greg KH <greg@kroah.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rndis: dhcp discover stopped working
Message-ID: <20110411210247.GB15419@kroah.com>
References: <20110411205440.GA4227@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411205440.GA4227@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:54:40PM +0300, Sergey Senozhatsky wrote:
> Hello,
> Seems like dhcp discover stopped working with my HTC in "USB-tethering" mode:
> 
> kernel: [   60.670379] usb 2-1.3: new high speed USB device number 4 using ehci_hcd
> kernel: [   60.766779] usb 2-1.3: New USB device found, idVendor=0bb4, idProduct=0c87
> kernel: [   60.766787] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> kernel: [   60.766792] usb 2-1.3: Product: Android Phone
> kernel: [   60.766796] usb 2-1.3: Manufacturer: HTC
> kernel: [   60.766800] usb 2-1.3: SerialNumber: HT082PL07557
> kernel: [   60.861976] Initializing USB Mass Storage driver...
> kernel: [   60.862395] scsi4 : usb-storage 2-1.3:1.0
> kernel: [   60.862965] usbcore: registered new interface driver usb-storage
> kernel: [   60.862972] USB Mass Storage support registered.
> kernel: [   61.865117] scsi 4:0:0:0: Direct-Access     HTC      Android Phone    0100 PQ: 0 ANSI: 2
> kernel: [   61.874518] sd 4:0:0:0: [sdb] Attached SCSI removable disk
> kernel: [   72.129190] usb 2-1.3: USB disconnect, device number 4
> kernel: [   72.454846] usb 2-1.3: new high speed USB device number 5 using ehci_hcd
> kernel: [   72.551186] usb 2-1.3: New USB device found, idVendor=0bb4, idProduct=0ffe
> kernel: [   72.551195] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> kernel: [   72.551200] usb 2-1.3: Product: Android Phone
> kernel: [   72.551205] usb 2-1.3: Manufacturer: HTC
> kernel: [   72.551242] usb 2-1.3: SerialNumber: HT082PL07557
> kernel: [   72.572416] rndis_host 2-1.3:1.0: usb0: register 'rndis_host' at usb-0000:00:1d.0-1.3, RNDIS device, e6:99:59:e3:8c:98
> kernel: [   87.281911] NET: Registered protocol family 10
> kernel: [   87.284969] ADDRCONF(NETDEV_UP): eth0: link is not ready
> dhclient: can't create /var/db/dhclient.leases: No such file or directory
> dhclient: DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 8
> kernel: [   98.003895] usb0: no IPv6 routers present
> dhclient: DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 8
> dhclient: DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 11
> dhclient: DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 15
> dhclient: DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 19
> dhclient: No DHCPOFFERS received.
> dhclient: No working leases in persistent database - sleeping.
> 
> 
> kernel: .39-rc2-*

Known bug, a patch was posted that fixed this already...

thanks,

greg k-h

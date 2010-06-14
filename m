Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0FNV05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:26:57 -0400
Received: from clueserver.org ([65.102.45.174]:56203 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab0FNV04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:26:56 -0400
Message-ID: <54979.10.6.6.23.1276550815.squirrel@10.6.6.2>
Date: Mon, 14 Jun 2010 14:26:55 -0700 (PDT)
Subject: Possible NetworkManager problem with 2.6.35-rc3
From: "Alan" <alan@clueserver.org>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get my sata controller to work I built a current kernel using
the config file from my Fedora 13 system.

Everything works except for networking.

It uses the forcedeth driver, but network manager does not want to see the
card whatsoever.

When I try and start the card through /etc/init.d/network start I get
messages about not being able to start the connection.



Jun 14 13:43:43 zowie NetworkManager[894]:    ifcfg-rh: Acquired D-Bus
service com.redhat.ifcfgrh1
Jun 14 13:43:43 zowie NetworkManager[894]: <info> Loaded plugin ifcfg-rh:
(c) 2007 - 2008 Red Hat, Inc.  To report bugs please use the
NetworkManager mailing list.
Jun 14 13:43:43 zowie NetworkManager[894]:    ifcfg-rh: parsing
/etc/sysconfig/network-scripts/ifcfg-lo ...
Jun 14 13:43:43 zowie NetworkManager[894]:    ifcfg-rh: parsing
/etc/sysconfig/network-scripts/ifcfg-eth0 ...
Jun 14 13:43:43 zowie NetworkManager[894]:    ifcfg-rh:     warning:
NM_CONTROLLED was false but HWADDR was missing; device will be managed
Jun 14 13:43:43 zowie NetworkManager[894]:    ifcfg-rh:     read
connection 'System eth0'
Jun 14 13:43:43 zowie NetworkManager[894]:    ifcfg-rh: parsing
/etc/sysconfig/network-scripts/ifcfg-eth1 ...
Jun 14 13:43:43 zowie NetworkManager[894]:    ifcfg-rh:     read
connection 'System eth1'
Jun 14 13:43:43 zowie NetworkManager[894]: <info> WiFi enabled by radio
killswitch; enabled by state file
Jun 14 13:43:43 zowie NetworkManager[894]: <info> WWAN enabled by radio
killswitch; enabled by state file
Jun 14 13:43:43 zowie NetworkManager[894]: <info> WiMAX enabled by radio
killswitch; enabled by state file
Jun 14 13:43:43 zowie NetworkManager[894]: <info> Networking is enabled by
state file
Jun 14 13:43:43 zowie NetworkManager[894]: <warn> /sys/class/net/eth0:
couldn't determine device driver; ignoring...
Jun 14 13:43:43 zowie NetworkManager[894]: <warn> /sys/class/net/eth1:
couldn't determine device driver; ignoring...
Jun 14 13:43:43 zowie NetworkManager[894]: <info> modem-manager is now
available
Jun 14 13:43:43 zowie NetworkManager[894]: <warn> bluez error getting
default adapter: The name org.bluez was not provided by any .service files
Jun 14 13:43:43 zowie NetworkManager[894]: <info> Trying to start the
supplicant...

Is there something special I have to set in the kernel config to get this
to work or do I have to get a new version of Network Manager.

It looks like it cannot find all of the driver information.

Any ideas?


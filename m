Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab1HBOoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:44:21 -0400
Received: from blu0-omc1-s7.blu0.hotmail.com ([65.55.116.18]:8108 "EHLO
	blu0-omc1-s7.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342Ab1HBOoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:44:16 -0400
X-Originating-IP: [76.64.132.10]
X-Originating-Email: [mpalenik@sympatico.ca]
Message-ID: <BLU0-SMTP412A7434C588C9EBCFA177A83B0@phx.gbl>
Date: Tue, 2 Aug 2011 10:44:19 -0400
From: Martin Palenik <mpalenik@sympatico.ca>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem Kernel: 2.6.39.3 - ethernet e1000 dropping bogus packets
 ifconfig bond0
References: <4E380CF6.1030702@sympatico.ca>
In-Reply-To: <4E380CF6.1030702@sympatico.ca>
X-Forwarded-Message-Id: <4E380CF6.1030702@sympatico.ca>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Aug 2011 14:44:14.0758 (UTC) FILETIME=[A64B1C60:01CC5122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel version 2.6.39.3

ifconfig is reporting thousands of dropped packets on a bonded ethernet 
connection.

This does not happen on earlier linux kernels such as 2.6.32

ethernet driver is intel e1000

Gnu C                  4.4.3
Gnu make               3.81
binutils               2.20.1
util-linux             2.17.2
mount                  support
module-init-tools      3.11.1
e2fsprogs              1.41.11
PPP                    2.4.5
Linux C Library        2.11.1
Dynamic linker (ldd)   2.11.1
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
Sh-utils               7.4
wireless-tools         30
Modules Loaded         vboxnetadp vboxnetflt vboxdrv bonding joydev 
w83627ehf hwmon_vid coretemp intel_agp lp intel_gtt parport usbhid hid 
psmouse serio_raw ses enclosure ahci e1000e libahci

These drops seem to occur when there is little traffic.  If I do a 
tcpdump -i  bond0  no packets are reported dropped in ifconfig nor in 
tcpipdump.  So it seems to be bogus dropped packets reported by ifconfig.

Thank you for your time.

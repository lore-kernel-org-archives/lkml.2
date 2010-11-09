Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0KIWA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:00:26 -0500
Received: from b.mail.sonic.net ([64.142.19.5]:59284 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab0KIWAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:00:22 -0500
X-Greylist: delayed 2196 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 17:00:21 EST
Subject: Re: [Wireshark-dev] usbmon: size of different fields?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
From: Guy Harris <guy@alum.mit.edu>
In-Reply-To: <4CD9A96D.1010306@freemail.hu>
Date: Tue, 9 Nov 2010 13:23:28 -0800
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E6FD75ED-7E13-47DC-B9F9-6C8C09C3C4AC@alum.mit.edu>
References: <4CD8ECE4.1090206@freemail.hu> <20101109075056.59a2e7d8@lembas.zaitcev.lan> <4CD9A96D.1010306@freemail.hu>
To: Developer support list for Wireshark <wireshark-dev@wireshark.org>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 9, 2010, at 12:05 PM, Németh Márton wrote:

> OK, that's clear, the byte order of the API structure fields are in "host endian"
> order. The API structures are already saved by Wireshark into file for quite some
> time.

...and tcpdump.  Support for capturing on USB on Linux has been in libpcap since at least libpcap 1.0.

When reading a pcap file, or a pcap-ng file section, written on a machine with a byte order opposite from that of the machine reading the file, libpcap and Wireshark's Wiretap library byte-swap most host-byte-order fields into the byte order of the host reading the file; the exceptions are the iso_rec structure and the isochronous descriptors.

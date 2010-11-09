Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab0KIGkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 01:40:41 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:34715 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab0KIGkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 01:40:40 -0500
Message-ID: <4CD8ECE4.1090206@freemail.hu>
Date: Tue, 09 Nov 2010 07:40:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
        Developer support list for Wireshark 
	<wireshark-dev@wireshark.org>
Subject: usbmon: size of different fields?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 178.164.145.38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking at the struct mon_bin_hdr and struct mon_bin_isodesc in file
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/usb/mon/mon_bin.c;h=44cb37b5a4dc1f9b27075e3db5346b9ebe307b22;hb=HEAD

As far as I understand u64, s64, u32 and s32 have always fixed bit lengths.

What about "unsigned char", "char", "unsigned int" and "int"? May their size in bits
differ in different architecture?

I'm asking this because I was dealing with the USB packet dissectors for Wireshark
and it is possible to capture the USB traffic on one computer and then transfer
the file to another computer.

	Márton Németh


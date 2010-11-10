Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0KJPUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:20:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab0KJPUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:20:43 -0500
Date: Wed, 10 Nov 2010 08:21:23 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Guy Harris <guy@alum.mit.edu>
Cc: Developer support list for Wireshark 
	<wireshark-dev@wireshark.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: usbmon: size of different fields?
Message-ID: <20101110082123.2dc1d361@lembas.zaitcev.lan>
In-Reply-To: <E6FD75ED-7E13-47DC-B9F9-6C8C09C3C4AC@alum.mit.edu>
References: <4CD8ECE4.1090206@freemail.hu>
	<20101109075056.59a2e7d8@lembas.zaitcev.lan>
	<4CD9A96D.1010306@freemail.hu>
	<E6FD75ED-7E13-47DC-B9F9-6C8C09C3C4AC@alum.mit.edu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 13:23:28 -0800
Guy Harris <guy@alum.mit.edu> wrote:
> On Nov 9, 2010, at 12:05 PM, Németh Márton wrote:
> 
> > OK, that's clear, the byte order of the API structure fields are in "host endian"
> > order. The API structures are already saved by Wireshark into file for quite some
> > time.
> 
> ...and tcpdump.  Support for capturing on USB on Linux has been in
> libpcap since at least libpcap 1.0.

I imagined that Nemeth wanted to implement an alternative to that.
Surely he knows how libpcap works. In that case a new, host-independent
format may be introduced. But userland is mysterious to me.

I'll make sure to document ISO descriptors properly. I was sure
I had done that, sorry.

-- Pete

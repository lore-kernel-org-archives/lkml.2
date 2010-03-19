Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab0CSLFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 07:05:30 -0400
Received: from node01-shml-0001.s.ipeer.se ([213.180.89.85]:56141 "EHLO
	shml-0001.s.ipeer.se" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252Ab0CSLFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 07:05:16 -0400
Message-ID: <4BA358DB.20708@enmesh.se>
Date: Fri, 19 Mar 2010 11:58:35 +0100
From: Henrik Rydberg <rydberg@enmesh.se>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: input: mt: Software finger tracking in the kernel?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

there is an ongoing discussion about adding multitouch to X
(http://lists.x.org/archives/xorg-devel/2010-March/006206.html), which is
beginning to take on more solid form.

One of the suggestions emerging from that discussion is to add the software
finger tracking to the kernel. Back in summer 2009 when I thought about this, I
disregarded it as being too experimental. I have since then reconsidered,
starting to think it really is the right place.

The MT protocol allows applications to take advantage of multi-contact hardware,
but leaves the problems of finger tracking and filtering to the user. Arguably,
no application can make good use of MT without these, so the problem is pushed
forward, in this case to evdev or equivalent.

The knowledge of signal-to-noise ratios and prior input states resides in the
kernel. Because of this, the finger matching and filtering would naturally
reside within the kernel.

So, if there were to appear patches to include matching in the input core, would
you consider them? :-)

Cheers,
Henrik


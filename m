Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0EKRel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:34:41 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55536 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0EKRei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:34:38 -0400
X-Greylist: delayed 2558 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 13:34:38 EDT
Date: Wed, 12 May 2010 01:51:59 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: ipheth device not showing up
Message-ID: <20100511165159.GA9614@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone, 

(please cc)

since I didn't find a contact point for the ipheth driver I write here.
I am runnning git kernel from yesterday, and I am trying to get 
my iPhone connected to the laptop via the ipheth driver.

It actually looks good:
[46128.590402] usb 2-1: Product: iPhone
[46128.590407] usb 2-1: Manufacturer: Apple Inc.
[46128.590411] usb 2-1: SerialNumber: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
[46128.717504] ipheth 2-1:4.2: Apple iPhone USB Ethernet device attached

so it seems that there should be an ethernet device, but ifconfig -a
or any other way I can imagine to check does not show the new device.

Am I missing something?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
ALBUQUERQUE (n.)
A shapeless squiggle which is utterly unlike your normal signature,
but which is, nevertheless, all you are able to produce when asked
formally to identify yourself. Muslims, whose religion forbids the
making of graven images, use albuquerques to decorate their towels,
menu cards and pyjamas.
			--- Douglas Adams, The Meaning of Liff

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1AFUDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:03:44 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:4576 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1AFUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:03:43 -0500
X-SpamScore: -13
X-BigFish: VS-13(z21eRzbb2cKzz1202hzz8275dhz2dh2a8h637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw02.freescale.net;RD:de01egw02.freescale.net;EFVD:NLI
Message-ID: <4D26200A.6040208@freescale.com>
Date: Thu, 6 Jan 2011 14:03:22 -0600
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101213 Fedora/2.0.11-1.fc13 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Patch for 2.6.37.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

What is the process for getting a patch into 2.6.37.1?  I posted this patch last
month, hoping it would get into 2.6.37, but I was too late:

http://patchwork.ozlabs.org/patch/74171/

This patch will make it into 2.6.38.  I am hoping it will also go into 2.6.37.1,
but I've never submitted a patch for a maintenance release of the kernel.

Without this patch, audio is completely non-functional on the Freescale P1022DS
reference board.  I have no explanation why I didn't notice earlier that the
device tree for the board was wrong.

-- 
Timur Tabi
Linux kernel developer at Freescale


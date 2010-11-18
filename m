Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0KRCLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:11:42 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:36041 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab0KRCLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:11:40 -0500
Message-ID: <4CE48C2E.5080502@wytron.com.tw>
Date: Thu, 18 Nov 2010 10:15:10 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: lkml <linux-kernel@vger.kernel.org>, Baruch Siach <baruch@tkos.co.il>,
        Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il> <4CE373BC.30805@wytron.com.tw> <4CE42457.8090001@zytor.com>
In-Reply-To: <4CE42457.8090001@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa,

On 11/18/2010 02:52 AM, H. Peter Anvin wrote:
> Do you happen to have a sample STmicro part number?  Also, are you
> saying that EPCS is *only* serial flash, or only for the purpose of
> being programmed (as opposed to programming the FPGA afterwards)?  It
> just seems a bit surprising to me, since Xilinx right now seem to have a
> bit of an advantage over Altera in being able to boot from stock SPI
> flash...

EPCS16 = M25P16
EPCS64 = M25P64

Yes, EPCS is ONLY serial flash. The Altera EPCS controller is only SPI 
controller. It is well-known on Altera wiki and Altera forum.

You may use any stock SPI flash to replace EPCS as long as the access 
time met. Though Altera flash programming utility supports only limited 
brands, more SPI flash can be programmed using u-boot or Linux MTD. We 
often boot right out of SPI/EPCS, as it saves cost and space.

There is no difference between Altera and Xilinx in this aspect, except 
for their marketing approach.

Cheers,
Thomas
http://sopc.et.ntust.edu.tw/

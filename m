Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0KRCQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:16:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45459 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab0KRCQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:16:05 -0500
Message-ID: <4CE48C3A.2050506@zytor.com>
Date: Wed, 17 Nov 2010 18:15:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: lkml <linux-kernel@vger.kernel.org>, Baruch Siach <baruch@tkos.co.il>,
        Andrew Morton <akpm@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        Alex Gershgorin <agersh@rambler.ru>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il> <4CE373BC.30805@wytron.com.tw> <4CE42457.8090001@zytor.com> <4CE48C2E.5080502@wytron.com.tw>
In-Reply-To: <4CE48C2E.5080502@wytron.com.tw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 06:15 PM, Thomas Chou wrote:
> 
> EPCS16 = M25P16
> EPCS64 = M25P64
> 
> Yes, EPCS is ONLY serial flash. The Altera EPCS controller is only SPI 
> controller. It is well-known on Altera wiki and Altera forum.
> 
> You may use any stock SPI flash to replace EPCS as long as the access 
> time met. Though Altera flash programming utility supports only limited 
> brands, more SPI flash can be programmed using u-boot or Linux MTD. We 
> often boot right out of SPI/EPCS, as it saves cost and space.
> 
> There is no difference between Altera and Xilinx in this aspect, except 
> for their marketing approach.
> 

OK, that's rather funny.

	-hpa

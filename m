Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1GNLI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 07:08:57 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1680 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab1GNLI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 07:08:56 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4E1ECE3B.10308@broadcom.com>
Date: Thu, 14 Jul 2011 13:08:43 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
Organization: Broadcom
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Jonas Gorski" <jonas.gorski@gmail.com>
cc: "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org
Subject: Status of MIPS on 3.0.0-rc6 kernel
X-WSS-ID: 620010E85ZC697404-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

The (defconfig) mips kernel fails to build, with the error message:

arch/mips/kernel/i8259.c:240: error: unknown field 'resume' specified in 
initializer

I read on https://lkml.org/lkml/2011/6/1/37 that Geert Uytterhoeven 
encountered the same issue on June 1st.

Do you know if there are still known problems building a 3.0.0-rc6 MIPS 
kernel ?

Thanks,

Roland.


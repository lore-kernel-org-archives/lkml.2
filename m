Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3AJMXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:23:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36434 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3AJMXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:23:12 -0500
Message-ID: <50EEB2A4.3020103@ti.com>
Date: Thu, 10 Jan 2013 17:53:00 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, Kevin Hilman <khilman@deeprootsystems.com>,
        <hs@denx.de>
Subject: Re: [PATCH V3 0/3] ARM: davinci: da850: add pinctrl support
References: <1357813838-26511-1-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1357813838-26511-1-git-send-email-anilkumar.v@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/2013 4:00 PM, Kumar, Anil wrote:
> This set of patches adds:
> 
> * Add pinctrl-single for handling Padconf registers.
> * Add NAND node to export NAND functionality on da850 EVM.
> * Add NAND pinctrl node to do pin mux according to pinctrl-single driver.

Please do not spin versions so fast. Give some reasonable time for
discussion to close before you send a new version. Dont want to see a
flood of versions. It creates confusion.

Thanks,
Sekhar

PS: New address of Kevin Hilman per MAINTAINERS is
khilman@deeprootsystems.com

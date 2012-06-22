Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645Ab2FVIWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:22:03 -0400
Received: from service88.mimecast.com ([195.130.217.12]:48179 "EHLO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761630Ab2FVIWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:22:00 -0400
Message-ID: <4FE42964.8050404@arm.com>
Date: Fri, 22 Jun 2012 09:14:28 +0100
From: viresh kumar <viresh.kumar2@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: mmotm 2012-06-21-16-20 uploaded
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
In-Reply-To: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
X-MC-Unique: 112062209143105402
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/06/12 00:21, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2012-06-21-16-20 has been uploaded to
>
>    http://www.ozlabs.org/~akpm/mmotm/
>
> It contains the following patches against 3.5-rc3:
> (patches marked "*" will be included in linux-next)
>
> * clk-add-non-config_have_clk-routines.patch
> * clk-remove-redundant-depends-on-from-drivers-kconfig.patch
> * i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
> * usb-marvell-remove-conditional-compilation-of-clk-code.patch
> * usb-musb-remove-conditional-compilation-of-clk-code.patch
> * ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
> * net-c_can-remove-conditional-compilation-of-clk-code.patch
> * net-stmmac-remove-conditional-compilation-of-clk-code.patch
> * gadget-m66592-remove-conditional-compilation-of-clk-code.patch
> * gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
> * usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch

Hi Andrew,

You need

http://permalink.gmane.org/gmane.linux.ports.arm.kernel/172024

to make above patchset complete.

--
Viresh

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.


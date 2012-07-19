Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2GSLqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:46:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44522 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2GSLqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:46:45 -0400
Message-ID: <5007F39F.1020601@mev.co.uk>
Date: Thu, 19 Jul 2012 12:46:39 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 65/90] staging: comedi: dt3000: cleanup "find pci device"
 code
References: <201207181857.50208.hartleys@visionengravers.com>
In-Reply-To: <201207181857.50208.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 02:57, H Hartley Sweeten wrote:
> The "find pci device" code for this driver was split between
> two functions which could cause the driver to walk the pci
> bus multiple times while looking for a match.

Actually the original version only walks through the PCI devices once 
(due to the `from` parameter in dt_pci_find_device()), but your version 
is cleaner.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-



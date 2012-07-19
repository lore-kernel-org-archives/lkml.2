Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2GSJvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:51:02 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44250 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab2GSJvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:51:00 -0400
Message-ID: <5007D87F.7070209@mev.co.uk>
Date: Thu, 19 Jul 2012 10:50:55 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 22/90] staging: comedi: adv_pci_dio: remove CheckAndAllocCard()
References: <201207181834.15945.hartleys@visionengravers.com>
In-Reply-To: <201207181834.15945.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 02:34, H Hartley Sweeten wrote:
> This driver creates a linked list of all the pci devices in
> the system while it's looking for a match. It's only use is
> to determine if a device is "free" to use. The pci_is_enabled()
> helper can give us the same information. Use that instead and
> remove the linked list.

As mentioned in my replies to your patches to adv_pci1723 and 
adv_pci1710, pci_is_enabled() might not be sufficient.  I think it's 
better just to take out the free/in-use test.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-



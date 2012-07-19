Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2GSJlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:41:17 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44225 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab2GSJlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:41:16 -0400
Message-ID: <5007D637.4040106@mev.co.uk>
Date: Thu, 19 Jul 2012 10:41:11 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 19/90] staging: comedi: adv_pci1710: move comedi_pci_enable()
 into the attach
References: <201207181832.02040.hartleys@visionengravers.com>
In-Reply-To: <201207181832.02040.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-19 02:32, H Hartley Sweeten wrote:
> Use pci_is_enabled() in the "find pci device" function to determine if
> the found pci device is not in use and move the comedi_pci_enable() call
> into the attach.

As mentioned in my reply to your equivalent patch for adv_pci1723, you 
should remove the pci_is_enabled() test for the same reason.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-



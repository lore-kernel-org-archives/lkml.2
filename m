Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab2DZUnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:43:19 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:14000
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756335Ab2DZUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:43:18 -0400
X-SpamScore: -6
X-BigFish: PS-6(zz1432Nzz1202hzzz2fh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT008.namprd08.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F99B34C.1000105@ozmodevices.com>
Date: Thu, 26 Apr 2012 21:42:52 +0100
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix bug where kfree is called twice.
References: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com> <20120426063858.GC6447@mwanda> <4F990AE0.8040400@ozmodevices.com> <20120426115459.GE6447@mwanda> <4F99813B.1010806@ozmodevices.com> <20120426194845.GA10724@kroah.com>
In-Reply-To: <20120426194845.GA10724@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2.126.200.180]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Is it possible to queue it up for 3.4 as well ?
> Yes, now done so.
>
>

Thanks a lot Greg.  :-)

-- 
Regards,
Rupesh Gujare



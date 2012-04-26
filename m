Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2DZRJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:09:34 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:28920
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757624Ab2DZRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:09:33 -0400
X-SpamScore: -5
X-BigFish: PS-5(zz154dMzz1202hzzz2fh2a8h668h839hd25he5bh)
X-Forefront-Antispam-Report: CIP:157.55.49.13;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0802HT003.namprd08.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F99813B.1010806@ozmodevices.com>
Date: Thu, 26 Apr 2012 18:09:15 +0100
From: Rupesh Gujare <rgujare@ozmodevices.com>
Organization: Ozmo Devices
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix bug where kfree is called twice.
References: <1335394498-5046-1-git-send-email-rgujare@ozmodevices.com> <20120426063858.GC6447@mwanda> <4F990AE0.8040400@ozmodevices.com> <20120426115459.GE6447@mwanda>
In-Reply-To: <20120426115459.GE6447@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.149.82.179]
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> Everything goes into linux-next first. That should have been put in 
> the changelog. "We are seeing occasional crashes under load" or 
> whatever... It's Greg's call and all, but generally it can't hurt to 
> ask nicely if you want stuff merged it into 3.4 as well. ;) 

Is it possible to queue it up for 3.4 as well ?

-- 
Regards,
Rupesh Gujare



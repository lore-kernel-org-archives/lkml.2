Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0LMVbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:31:18 -0500
Received: from mailb.microsoft.com ([131.107.115.215]:15224 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0LMVbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:31:17 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Ky Srinivasan <ksrinivasan@novell.com>
Subject: RE: [PATCH 1/1] hv: Use only one txf buffer per channel and kmalloc
 on initialize
Thread-Topic: [PATCH 1/1] hv: Use only one txf buffer per channel and
 kmalloc on initialize
Thread-Index: AQHLmwp4yLbHTb01E0ye4GCCvXnmhJOfZ6KA//9710A=
Date: Mon, 13 Dec 2010 21:31:09 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5622C0BCDFC@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1292274861-29673-1-git-send-email-hjanssen@microsoft.com>
 <alpine.LNX.2.00.1012132220220.26491@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012132220220.26491@swampdragon.chaosbits.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Jesper Juhl [mailto:jj@chaosbits.net]
> Sent: Monday, December 13, 2010 1:22 PM
> 
> I can't spot any problems with these changes now, so feel free to add
>   Reviewed-by: Jesper Juhl <jj@chaosbits.net> if you like.
> 

Thank you for your help Jesper.

Greg, do you want me to resubmit with the Reviewed by line? Or do you 
Add it once you queue it up for linux-next?

Thanks,

Hank.


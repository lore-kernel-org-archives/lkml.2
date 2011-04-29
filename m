Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687Ab1D2RkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:40:07 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:54018 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957Ab1D2RkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:40:06 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: RE: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Topic: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Thread-Index: AQHMBCwlOahkyDWQA0Cj/4uI6AAO6ZRxNFuA///EzKCAAef0AIAB4skAgACoXgD//7LvYA==
Date: Fri, 29 Apr 2011 17:40:04 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481DD6D6@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
 <20110426224545.GC31974@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110428002018.GC14294@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD55F@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110429151052.GC12142@suse.de>
In-Reply-To: <20110429151052.GC12142@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, April 29, 2011 11:11 AM
> To: KY Srinivasan
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Abhishek Kane (Mindtree Consulting
> PVT LTD)
> Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
> cleanup accordingly
> 
> On Fri, Apr 29, 2011 at 01:49:21PM +0000, KY Srinivasan wrote:
> 
> Just resend it with some more comments as I explained, and the rest, and
> I'll queue them up when I get caught up on my patch queue (I only have
> 381 to get through, the end is near!)

Thanks Greg; soon after I sent you this patch-set, I had also sent a single patch to
address a redundant assignment:

0001-Staging-hv-Do-not-re-set-the-bus-name.patch

Please drop this patch. I will deal with this issue as part of the remaining patch-set
I will be sending now.

Regards,

K. Y


 
> 
> thanks,
> 
> greg k-h


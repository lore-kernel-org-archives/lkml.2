Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032410Ab2COX1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:27:10 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:42400
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032060Ab2COX1C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:27:02 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz9371I1454I542M1432N98dKzz1202hzz8275bhz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC105.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>
Subject: RE: [PATCH 0000/0004] drivers: hv
Thread-Topic: [PATCH 0000/0004] drivers: hv
Thread-Index: AQHM/xUNOy6yOVAGgUil/yR0GrM6q5ZoyHoAgAM/EEA=
Date: Thu, 15 Mar 2012 23:26:51 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B766384@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1331422300-4330-1-git-send-email-kys@microsoft.com>
 <20120313215036.GA4972@kroah.com>
In-Reply-To: <20120313215036.GA4972@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, March 13, 2012 5:51 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; ohering@suse.com
> Subject: Re: [PATCH 0000/0004] drivers: hv
> 
> On Sat, Mar 10, 2012 at 03:31:40PM -0800, K. Y. Srinivasan wrote:
> >
> > This patch-set further enhances the KVP functionality for Linux
> > guests:
> >
> > 	1. Supports most of the Win8 KVP protocol.
> > 	2. Supports operations on all the pools.
> 
> I've only applied the first patch, due to the issues with the second.
> Feel free to resend the rest when you have them worked out.

Thanks Greg. I don't think there are any substantive issues with the remaining 
patches. I will fix them up and re-send them soon.

K. Y



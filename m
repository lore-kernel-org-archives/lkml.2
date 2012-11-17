Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2KQLNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 06:13:22 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1795 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab2KQLNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 06:13:20 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <1353150776.14327.13.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: Re: [PATCH] checkpatch: add double empty line check
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Joe Perches" <joe@perches.com>
cc: "David Rientjes" <rientjes@google.com>,
        "Andy Whitcroft" <apw@canonical.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Sat, 17 Nov 2012 13:12:56 +0200
In-Reply-To: <1353113454.2512.21.camel@joe-AO722>
References: <1353094919.14327.4.camel@lb-tlvb-eilong.il.broadcom.com>
 <alpine.DEB.2.00.1211161154280.2788@chino.kir.corp.google.com>
 <1353096274.14327.9.camel@lb-tlvb-eilong.il.broadcom.com>
 <1353113454.2512.21.camel@joe-AO722>
Organization: Broadcom
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-Version: 1.0
X-WSS-ID: 7CB9AFDF3P84212350-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 16:50 -0800, Joe Perches wrote:

Hi Joe, thanks for replying.

> On Fri, 2012-11-16 at 22:04 +0200, Eilon Greenstein wrote:
> > On Fri, 2012-11-16 at 11:55 -0800, David Rientjes wrote:
> > > On Fri, 16 Nov 2012, Eilon Greenstein wrote:

> > > This is fairly common in all the acpi code where variables declared in a 
> > > function are separated from the code in a function.
> > > 
> > 
> > Indeed, I see that you do use it in some functions.
> > 
> > Maybe we can limit it only to the networking tree (similar to the
> > networking comments style) or if the ACPI is the exception, we can apply
> > to all but ACPI.
> 
> I'm not sure this should be done.
> Double line spacing has some utility and
> is pretty common.

Since adding double empty line can cause a patch to be rejected, we
should have an easy way to catch it before submitting.

> Perhaps make this a --strict/CHK option
> and also perhaps make sure this isn't
> emitted on consecutive lines.

Indeed, CHK makes more sense. I wanted to have a warning per redundant
line, but since it can be annoying when adding 3 or more empty lines
intentionally, I will issue one comment for consecutive lines.

v2 is on its way.

Thanks,
Eilon




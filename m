Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0LMVRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:17:01 -0500
Received: from mailc.microsoft.com ([131.107.115.214]:14540 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab0LMVRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:17:00 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Jesper Juhl <jj@chaosbits.net>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Ky Srinivasan <ksrinivasan@novell.com>
Subject: RE: [PATCH 1/1] hv: Use only one receive buffer per channel and
 kmalloc on initialize
Thread-Topic: [PATCH 1/1] hv: Use only one receive buffer per channel and
 kmalloc on initialize
Thread-Index: AQHLmwTWTCfBOZ+WHUG7YLQqdwCl/JOfXiMA//9+/JCAAIYTAP//fHXw
Date: Mon, 13 Dec 2010 21:16:59 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5622C0BCDAD@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1292272498-29483-1-git-send-email-hjanssen@microsoft.com>
 <alpine.LNX.2.00.1012132143590.26491@swampdragon.chaosbits.net>
 <8AFC7968D54FB448A30D8F38F259C5622C0BCB78@TK5EX14MBXC116.redmond.corp.microsoft.com>
 <alpine.LNX.2.00.1012132204240.26491@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1012132204240.26491@swampdragon.chaosbits.net>
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



> -----Original Message-----
> From: Jesper Juhl [mailto:jj@chaosbits.net]
> Sent: Monday, December 13, 2010 1:06 PM
> On Mon, 13 Dec 2010, Hank Janssen wrote:
> > > ...
> > >
> >
> > Oops, you are correct. Resubmitting the patch in a few minutes.
> >
> Ohh and another little detail; shouldn't this log message be a
> KERN_WARNING level message?
> And perhaps the log text should include "HyperV" or something so it's clear
> where it comes from..?
> 

I will make that part of another set of patches. I need to remove the DPRINT
Completely from the code and replace them all with the correct kprint statements.

Hank.


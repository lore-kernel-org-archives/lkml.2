Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0KBVHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 17:07:08 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:19355 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0KBVHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 17:07:05 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Brandon Philips <brandon@ifup.org>
CC: Hank Janssen <hjanssen@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 05/10] staging: hv: Convert camel cased functions in
 hv.c to lower cases
Thread-Topic: [PATCH 05/10] staging: hv: Convert camel cased functions in
 hv.c to lower cases
Thread-Index: AQHLegWyysIi3s3LCUKTlGhWblKLdZNe4TkA///MvGA=
Date: Tue, 2 Nov 2010 21:06:56 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF728BA55BD7@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1288644369-12958-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-4-git-send-email-haiyangz@linuxonhyperv.com>
 <1288644369-12958-5-git-send-email-haiyangz@linuxonhyperv.com>
 <20101102170406.GA4557@jenkins.home.ifup.org>
In-Reply-To: <20101102170406.GA4557@jenkins.home.ifup.org>
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

> From: Brandon Philips [mailto:brandon@ifup.org]
> Sent: Tuesday, November 02, 2010 1:04 PM
> > -static int HvQueryHypervisorInfo(void)
> > +static int hvquery_hypervisor_info(void)
> > -static u64 HvDoHypercall(u64 control, void *input, void *output)
> > +static u64 hvdo_hypercall(u64 control, void *input, void *output)
> 
> Should these be hv_do_hypercall and hv_query_hypervisor? That seems to
> be the style in the rest of the patch:

I didn't insert underscore between every word, for example, it's not
added between two short words.

Thanks,
- Haiyang

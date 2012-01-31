Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2AaXIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 18:08:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:65067 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab2AaXIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 18:08:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118790172"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: David Ahern <daahern@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: VFs go missing with latest kernel
Thread-Topic: VFs go missing with latest kernel
Thread-Index: AQHM4Gs6ffY5XbLoAUGa1L3askdwe5YnFpYAgACIMwD//3qD0A==
Date: Tue, 31 Jan 2012 23:07:56 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F648D3@ORSMSX106.amr.corp.intel.com>
References: <4F287102.3060600@cisco.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
 <4F28739C.1040907@cisco.com>
In-Reply-To: <4F28739C.1040907@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Ahern [mailto:daahern@cisco.com]
> Sent: Tuesday, January 31, 2012 3:05 PM
> To: Rose, Gregory V
> Cc: LKML
> Subject: Re: VFs go missing with latest kernel
> 
>
> > I'll see if I can reproduce that.  Is this all after a fresh boot with
> no unloading/reloading of the PF driver?
> 
> Build kernel, reboot, run lspci - note missing VFs.

Thanks.  Would you mind sending me your kernel log output from dmesg?

- Greg



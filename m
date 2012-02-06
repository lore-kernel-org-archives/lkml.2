Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2BFSgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:36:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:4655 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2BFSgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:36:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="107009490"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: =?iso-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
Thread-Topic: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
Thread-Index: AQHM4tRzTeNX1pwK8UWzJpDyRUwPApYvSQxggADQ/QCAAAhUQIAAmWMA//96mkA=
Date: Mon, 6 Feb 2012 18:36:03 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F80AEB@ORSMSX106.amr.corp.intel.com>
References: <5422254.3711328278789768.JavaMail.root@5-MeO-DMT.ynet.sk>
 <10521320.3761328279061644.JavaMail.root@5-MeO-DMT.ynet.sk>
 <20120203.192933.510206531351047222.davem@davemloft.net>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F7F86F@ORSMSX106.amr.corp.intel.com>
 <CAGsizzLFoXdUQrA-WtdRq4FDdnDNnevyK6HCRmrT2joUV=ZRXg@mail.gmail.com>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F806E3@ORSMSX106.amr.corp.intel.com>
 <CAGsizzKVMHT2TUK2O0odbpm6tkMHq9isSOZcjEies+fOOkURYA@mail.gmail.com>
In-Reply-To: <CAGsizzKVMHT2TUK2O0odbpm6tkMHq9isSOZcjEies+fOOkURYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: steweg@gmail.com [mailto:steweg@gmail.com] On Behalf Of ©tefan Gula
> Sent: Monday, February 06, 2012 10:32 AM
> To: Rose, Gregory V
> Cc: David Miller; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [patch v1, kernel version 3.2.1] rtnetlink workaround around
> the skb buff size issue
> 
> 2012/2/6 Rose, Gregory V <gregory.v.rose@intel.com>:
> > That is exactly my approach.  We currently have a *bug* in the kernel
> that this patch is addressing.  The kernel is attempting to provide too
> much information for the netlink interface to handle and it's breaking
> things.  So what I want to do is fix the immediate problem while still
> providing a way for folks to get the information they need.  I've
> accomplished this by doing exactly what Dave asked me to do, provide a
> filter that defaults to off and then provide a way for the user to request
> discrete chunks of information in the dump that won't exceed the netlink
> buffer limits.
> >
> > The patch is fairly unobtrusive and simple to understand.
> >
> > I appreciate that it doesn't do all that you'd like to see done and I
> see no reason why you couldn't go on and develop the extended features
> that you would like to see, correct?  There's nothing in my patch that
> would prevent that so far as I can tell, although I'm not that familiar
> with your requirements or proposals yet.
> Greg, your patch is completely ok for filtering. I like that thing. I
> am just stating that it doesn't eliminate every possible option that
> can happen so I believe we should also have method for using cycles -
> that's what my patch is doing. So I believe both approaches should be
> applied.

OK, good deal.  I'll go ahead and finish up my kernel patch and the associated iproute2 patch.

Thanks,

- Greg


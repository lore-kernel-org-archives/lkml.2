Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2CXDeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 23:34:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:29593 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755793Ab2CXDeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 23:34:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ75kXZ_coHKo3ZXEFxv4HPo=BHA6=LCTWcTkxb_UTdJL-WScw@mail.gmail.com>
References: <20120302055715.GA692@burratino>
	<CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	<20120302162159.GB31683@wavehammer.waldi.eu.org>
	<CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
	<20120302175719.GA1468@wavehammer.waldi.eu.org>
	<CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
	<4F54DB1F.3080000@debian.org>
	<CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
	<4F55D6F6.2040906@debian.org>
	<CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
	<20120311220648.GA8120@burratino>
	<1332546904.23830.8.camel@ultramagnus.opencreations.com>
	<CAJ75kXZ_coHKo3ZXEFxv4HPo=BHA6=LCTWcTkxb_UTdJL-WScw@mail.gmail.com>
Date: Fri, 23 Mar 2012 20:34:13 -0700
Message-ID: <CABE8wwv3JZeg2UfkkEa-+g1BDuGchJCbvk_oGvYAjj6fO6+vWQ@mail.gmail.com>
Subject: Re: ioatdma: Boot process hangs then reboots when using Xen + Linux 3.2
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Thomas Goirand <zigo@debian.org>,
        xen-devel@lists.xensource.com, Dave Jiang <dave.jiang@intel.com>,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 7:25 PM, William Dauchy <wdauchy@gmail.com> wrote:
> Hi Dan,
>
> On Sat, Mar 24, 2012 at 12:55 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> Thanks for the debug help, does this patch fix the issue for you?
>
> I successfully tested your patch and it works fine. Thanks again for your work.
>
> Reported-by: William Dauchy <wdauchy@gmail.com>
> Tested-by: William Dauchy <wdauchy@gmail.com>

Great, thanks for the test.

--
Dan

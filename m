Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2CXC0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 22:26:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51143 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2CXC0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 22:26:07 -0400
MIME-Version: 1.0
In-Reply-To: <1332546904.23830.8.camel@ultramagnus.opencreations.com>
References: <20120302055715.GA692@burratino> <CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
 <20120302162159.GB31683@wavehammer.waldi.eu.org> <CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
 <20120302175719.GA1468@wavehammer.waldi.eu.org> <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
 <4F54DB1F.3080000@debian.org> <CABE8wwtOwgiYwb-_g-3Fg_QH6ph7LEPdkcOff94inDFvs9kwxA@mail.gmail.com>
 <4F55D6F6.2040906@debian.org> <CABE8wwsPA2PUx45EbY3w3BAHaHbUMWo7+giK=uU8gx9mbBkRpQ@mail.gmail.com>
 <20120311220648.GA8120@burratino> <1332546904.23830.8.camel@ultramagnus.opencreations.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Sat, 24 Mar 2012 03:25:46 +0100
Message-ID: <CAJ75kXZ_coHKo3ZXEFxv4HPo=BHA6=LCTWcTkxb_UTdJL-WScw@mail.gmail.com>
Subject: Re: ioatdma: Boot process hangs then reboots when using Xen + Linux 3.2
To: Dan Williams <dan.j.williams@intel.com>
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

Hi Dan,

On Sat, Mar 24, 2012 at 12:55 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Thanks for the debug help, does this patch fix the issue for you?

I successfully tested your patch and it works fine. Thanks again for your work.

Reported-by: William Dauchy <wdauchy@gmail.com>
Tested-by: William Dauchy <wdauchy@gmail.com>

Best regards,
-- 
William

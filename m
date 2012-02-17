Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab2BQHRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 02:17:31 -0500
Received: from mail2.nsc.com ([12.238.8.132]:48130 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751027Ab2BQHRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 02:17:30 -0500
X-WSS-ID: 0LZJ091-0A-2TC-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 16 Feb 2012 23:17:22 -0800
Subject: RE: [PATCH 1/3] regulator: fix wrong header name in description
Thread-Topic: [PATCH 1/3] regulator: fix wrong header name in
 description
Thread-Index: AcztQza/gpqCqlFlQw+hI4XLd4qS8wAACqsA
Message-ID: <B567DBAB974C0544994013492B949F8E381301287B@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E381301284C@EXMAIL03.scwf.nsc.com>
 <20120217071013.GB11464@opensource.wolfsonmicro.com>
In-Reply-To: <20120217071013.GB11464@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6323208E1LS10441099-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, thanks for your advice.
Then should I resend other two patches based on linux-next tree ?

Milo -

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Friday, February 17, 2012 4:10 PM
> To: Kim, Milo
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/3] regulator: fix wrong header name in
> description
> 
> On Thu, Feb 16, 2012 at 10:41:32PM -0800, Kim, Milo wrote:
> > The 'mode' is defined in consumer.h.
> >
> > * patch base version : linux-3.2.4
> 
> Applied, thanks, but you should only include administrative stuff like
> the above after the ---.  You should also always submit patches against
> either Linus' tree (for fixes) or -next (for everything else) rather
> than an old kernel.


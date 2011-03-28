Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab1C1O67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:58:59 -0400
Received: from mx5.twosigma.com ([208.77.212.35]:59492 "EHLO mx5.twosigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab1C1O66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:58:58 -0400
From: Sean Noonan <Sean.Noonan@twosigma.com>
To: "'Michel Lespinasse'" <walken@google.com>,
        Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Mon, 28 Mar 2011 10:58:53 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Thread-Topic: XFS memory allocation deadlock in 2.6.38
Thread-Index: AcvqfZivehhF+3ElQ0WLyr/42LSzHwC2ut6w
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
	<081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
	<20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
In-Reply-To: <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Regarding the deadlock: I am curious to see if it could be made to
> happen before 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272. Could you test
> what happens if you remove the MAP_POPULATE flag from your mmap call,
> and instead read all pages from userspace right after the mmap ? I
> expect you would then be able to trigger the deadlock before
> 5ecfda041e4b4bd858d25bbf5a16c2a6c06d7272.

I still see the deadlock without MAP_POPULATE

Sean

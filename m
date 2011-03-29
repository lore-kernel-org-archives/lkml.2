Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1C2WpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:45:21 -0400
Received: from mx5.twosigma.com ([208.77.212.35]:56971 "EHLO mx5.twosigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1C2WpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:45:20 -0400
From: Sean Noonan <Sean.Noonan@twosigma.com>
To: "'Dave Chinner'" <david@fromorbit.com>,
        "'Christoph Hellwig'" <hch@infradead.org>
CC: Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>,
        "'Michel Lespinasse'" <walken@google.com>
Date: Tue, 29 Mar 2011 18:45:15 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Thread-Topic: XFS memory allocation deadlock in 2.6.38
Thread-Index: AcvuYpz7hovhsA6oREKqH6av+QvnaAAADQxQ
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B5361@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
 <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
 <20110329192434.GA10536@infradead.org>
 <081DDE43F61F3D43929A181B477DCA95639B535C@MSXAOA6.twosigma.com>
 <20110329200256.GA6019@infradead.org> <20110329224230.GH3008@dastard>
In-Reply-To: <20110329224230.GH3008@dastard>
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

> Need to keep the if (!irbuf) check as KM_MAYFAIL is passed.

It wasn't in before the bug presented, so leaving it in wouldn't be a true test as to whether the bug has been tracked to the correct place.  I'll test again with the if (!irbuf).

Sean

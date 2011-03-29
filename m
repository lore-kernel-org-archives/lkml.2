Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1C2TsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:48:11 -0400
Received: from mx5.twosigma.com ([208.77.212.35]:65418 "EHLO mx5.twosigma.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab1C2TsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:48:10 -0400
From: Sean Noonan <Sean.Noonan@twosigma.com>
To: "'Christoph Hellwig'" <hch@infradead.org>
CC: "'Michel Lespinasse'" <walken@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Date: Tue, 29 Mar 2011 15:46:21 -0400
Subject: RE: XFS memory allocation deadlock in 2.6.38
Thread-Topic: XFS memory allocation deadlock in 2.6.38
Thread-Index: AcvuRvK4VBD+qD8KS0ORKuK3roIztQAAvWNg
Message-ID: <081DDE43F61F3D43929A181B477DCA95639B535C@MSXAOA6.twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
 <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
 <20110329192434.GA10536@infradead.org>
In-Reply-To: <20110329192434.GA10536@infradead.org>
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

> Can you check if the brute force patch below helps?

No such luck.

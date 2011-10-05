Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934753Ab1JEOiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934392Ab1JEOiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:38:17 -0400
Date: Wed, 5 Oct 2011 16:38:04 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Kyungmin Park <kmpark@infradead.org>, Lukas Czerner <lczerner@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
In-Reply-To: <874o0xlb9p.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.1110051636220.4423@dhcp-27-109.brq.redhat.com>
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de> <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com> <201103301706.36214.arnd@arndb.de> <BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com> <87wrhgk8lp.fsf@devron.myhome.or.jp>
 <BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com> <87r57ok3fp.fsf@devron.myhome.or.jp> <BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com> <87mxick0zj.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241102200.5457@dhcp-27-109.brq.redhat.com>
 <874o4kjtsy.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241211100.4028@dhcp-27-109.brq.redhat.com> <87y61wic4h.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241319340.4028@dhcp-27-109.brq.redhat.com> <87sjs4i93w.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.00.1105241520260.4028@dhcp-27-109.brq.redhat.com> <87oc2si3l7.fsf@devron.myhome.or.jp> <CAH9JG2UDKD-tZPo-OiQmiheNvPqPE2o_cTEbc9M9Uu02HB6hcw@mail.gmail.com> <874o0xlb9p.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, OGAWA Hirofumi wrote:

> Kyungmin Park <kmpark@infradead.org> writes:
> 
> > Hi Ogawa,
> 
> Hi,
> 
> > Do you still object to merge batched discard support on fat?
> >
> > If the current batched discard concept doesn't changed, it can't merge it?
> 
> I'm not blaming "concept". I'm saying current implements (and due to
> current interface confusion) is confusing and makes userland hard to use it.
> 
> I really think I explained all my concerns and current implement
> confusion.
> 
> Last time I checked, those implementations had even the different error
> code at EOF. How can I say your implement will work without knowing
> right implement?
> 
> Again, it is reason, and I'm not blaming "concept" or your implement
> itself.
> 
> Thanks.

Please see test #260 in xfstests, which was recently added to check for
common mistakes in FITRIM argument handling.

Thanks!
-Lukas

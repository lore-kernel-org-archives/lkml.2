Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab1HaRvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:51:55 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:59645 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab1HaRvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:51:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de>
	<AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
	<201103301706.36214.arnd@arndb.de>
	<BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com>
	<87wrhgk8lp.fsf@devron.myhome.or.jp>
	<BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com>
	<87r57ok3fp.fsf@devron.myhome.or.jp>
	<BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com>
	<87mxick0zj.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241102200.5457@dhcp-27-109.brq.redhat.com>
	<874o4kjtsy.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241211100.4028@dhcp-27-109.brq.redhat.com>
	<87y61wic4h.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241319340.4028@dhcp-27-109.brq.redhat.com>
	<87sjs4i93w.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1105241520260.4028@dhcp-27-109.brq.redhat.com>
	<87oc2si3l7.fsf@devron.myhome.or.jp>
	<CAH9JG2UDKD-tZPo-OiQmiheNvPqPE2o_cTEbc9M9Uu02HB6hcw@mail.gmail.com>
Date: Thu, 01 Sep 2011 02:51:46 +0900
In-Reply-To: <CAH9JG2UDKD-tZPo-OiQmiheNvPqPE2o_cTEbc9M9Uu02HB6hcw@mail.gmail.com>
	(Kyungmin Park's message of "Wed, 31 Aug 2011 22:02:53 +0900")
Message-ID: <874o0xlb9p.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

> Hi Ogawa,

Hi,

> Do you still object to merge batched discard support on fat?
>
> If the current batched discard concept doesn't changed, it can't merge it?

I'm not blaming "concept". I'm saying current implements (and due to
current interface confusion) is confusing and makes userland hard to use it.

I really think I explained all my concerns and current implement
confusion.

Last time I checked, those implementations had even the different error
code at EOF. How can I say your implement will work without knowing
right implement?

Again, it is reason, and I'm not blaming "concept" or your implement
itself.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

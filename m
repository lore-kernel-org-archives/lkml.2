Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1KERIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 13:08:25 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58951 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753878Ab1KERIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 13:08:24 -0400
Message-Id: <1320512903.28230.140660995069181@webmail.messagingengine.com>
X-Sasl-Enc: 7MFo+aovzoEVGKEoIJdPho+GNa0h1akZu9utxeBKP3HB 1320512903
From: "Clayton Weaver" <cgweav@fastmail.fm>
To: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Date: Sat, 05 Nov 2011 10:08:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(NB: My only dog in this hunt is the length of this thread.)

When swapping to rotating media, all swapped pages have the same
age. Is there any performance reason to keep this property when
swapping to in-memory swap space that has rotating media or
some other longer-latency swap space for worst-case swap storage?
Is there any performance reason to extend lru logic to this type
of low-latency/high-latency swap?

Seems like an obvious question.

Will all of these potential frontswap backends want page compression?
(Should it be factored out into a common page compression
implementation that anything can use? Does this already exist? How
many pages should it operate on at one time, batched together to get
higher average compression ratios?)
-- 

Clayton Weaver
cgweav at fastmail dot fm


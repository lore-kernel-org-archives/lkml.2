Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1H2QYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:24:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45934 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab1H2QYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:24:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Ren, Yongjie" <yongjie.ren@intel.com>
Subject: Re: [Bug #39412] Win Vista and Win2K8 guests' network breaks down
Date: Mon, 29 Aug 2011 18:26:10 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
References: <Sm7qbRR0zn.A.yAG.LepWOB@chimera> <gUVi6eNP8RE.A.IBH.TfpWOB@chimera> <CE59C043D0EC3349B2BF41C0EC72229B12D24D15E8@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <CE59C043D0EC3349B2BF41C0EC72229B12D24D15E8@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291826.10441.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 29, 2011, Ren, Yongjie wrote:
> I've verified this bug in Linus' tree 3.1.0-rc4. It got fixed, so I closed the bug.
> The commit I tried is below.
> commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Aug 28 21:16:01 2011 -0700

Thanks, closing.

Rafael

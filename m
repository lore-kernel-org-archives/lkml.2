Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2C0Qd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:33:29 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:35500 "HELO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752688Ab2C0Qd1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:33:27 -0400
From: Tziporet Koren <tziporet@mellanox.com>
To: Roland Dreier <roland@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [GIT PULL] please pull infiniband.git
Thread-Topic: [GIT PULL] please pull infiniband.git
Thread-Index: AQHNBfNV99GZ7tvDO0+Ol3BBkzihDZZ9GzFg///iDYCAAWUygA==
Date: Tue, 27 Mar 2012 16:33:06 +0000
Message-ID: <CD250C48050CFB4D95E78C95F2FDDD6E61A7B8E9@MTLDAG02.mtl.com>
References: <1332177079-14339-1-git-send-email-roland@kernel.org>
 <CD250C48050CFB4D95E78C95F2FDDD6E61A79B2E@MTLDAG02.mtl.com>
 <CAG4TOxPHziBpJ5hAoVCQTJWeR+-uC+2vM9S0aKE-6-B9JCEkWQ@mail.gmail.com>
In-Reply-To: <CAG4TOxPHziBpJ5hAoVCQTJWeR+-uC+2vM9S0aKE-6-B9JCEkWQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.13.1]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> What about the IPoIB patches (e.g. use Interrupt moderation)

> I have no idea what patch that might be.  We've had the modify_cq call in ipoib for years now, with moderation parameters set through ethtool.

http://www.spinics.net/lists/linux-rdma/msg09142.html
 and
http://www.spinics.net/lists/linux-rdma/msg09143.html

Tziporet

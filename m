Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2KHWUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:20:20 -0500
Received: from co202.xi-lite.net ([149.6.83.202]:48752 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab2KHWUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:20:19 -0500
From: Matthieu Castet <matthieu.castet@parrot.com>
To: Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 8 Nov 2012 22:18:43 +0000
Subject: RE : [RFC] arm: memtest
Thread-Topic: [RFC] arm: memtest
Thread-Index: Ac2980EUdAq7+IjVSqKHNIE4KU2cQQAC8JAr
Message-ID: <C429A122CB68254FACED4BEF16AA357A2ACE7DD937@OPALE.xi-lite.lan>
References: <509C1A92.9080407@ahsoftware.de>
In-Reply-To: <509C1A92.9080407@ahsoftware.de>
Accept-Language: fr-FR
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note memtester is also a great userspace tool for testing memory :
http://pyropus.ca/software/memtester/

It works fine on arm and other arch (but work on malloc or /dev/mem memory)
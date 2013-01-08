Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3AHIyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:54:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:32226 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab3AHIyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:54:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="274159409"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Sedat Dilek <sedat.dilek@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [PATCH -next] mei: Fix typo "@hader" in mei_write_message()
Thread-Topic: [PATCH -next] mei: Fix typo "@hader" in mei_write_message()
Thread-Index: AQHN7Xz0QS0brCW3DkOFWqYelVi5w5g/IDNQ
Date: Tue, 8 Jan 2013 08:54:18 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01EADBDA@HASMSX106.ger.corp.intel.com>
References: <1357634896-9944-1-git-send-email-sedat.dilek@gmail.com>
In-Reply-To: <1357634896-9944-1-git-send-email-sedat.dilek@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This was introduced by:
> 
> commit 438763f37eb9664b6372bdfee990f8c33acdc63c
> "mei: drop redundant length parameter from mei_write_message function"
> 
> First seen in linux-next (next-20120108).
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
Thanks. Acked.
Tomas


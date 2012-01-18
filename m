Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2ARXUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:20:24 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:44383 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2ARXUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:20:23 -0500
X-Greylist: delayed 2372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jan 2012 18:20:23 EST
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Kees Cook <keescook@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jan 2012 18:20:08 -0500
Subject: RE: [PATCH v5] ramoops: use pstore interface
Thread-Topic: [PATCH v5] ramoops: use pstore interface
Thread-Index: AczWMzvu3M7seOBfSAOSsNKb293XNgAAXUfQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F237@USINDEVS01.corp.hds.com>
References: <20120117235852.GA4877@www.outflux.net>
	<20120118140603.0fc22302.akpm@linux-foundation.org>
	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
 <CAGXu5jJ3WMUDS0svkoviLx_OOQFdjofMt3PwHdeLiouFbDVShw@mail.gmail.com>
In-Reply-To: <CAGXu5jJ3WMUDS0svkoviLx_OOQFdjofMt3PwHdeLiouFbDVShw@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1201180254
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Are there any specific usecases you need to unload ramoops?
>
>For me, it would be useful during development. Beyond that, not that I can see.

Thank you for your quick relay. I understood this is useful for you.

But, as Tony said, I think this is a low priority because 
there is a side effect for end users.
If they unload ramoops by mistake, messages will be lost.

In my opinion, we have to consider whether each feature 
is truly needed for end users (not for developers).

Seiji


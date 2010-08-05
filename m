Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab0HELT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 07:19:59 -0400
Received: from mail.mellanox.co.il ([194.90.237.43]:38070 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759040Ab0HELT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 07:19:56 -0400
From: Tziporet Koren <tziporet@mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Date: Thu, 5 Aug 2010 14:19:53 +0300
Subject: RE: InfiniBand/RDMA merge plans for 2.6.36
Thread-Topic: InfiniBand/RDMA merge plans for 2.6.36
Thread-Index: Acs0LX+eamdEM0CFR7C0YygcQAs0qgAYnr1Q
Message-ID: <E113D394D7C5DB4F8FF691FA7EE9DB443B50B5FD12@MTLMAIL.mtl.com>
References: <adak4o654x9.fsf@roland-alpha.cisco.com>
In-Reply-To: <adak4o654x9.fsf@roland-alpha.cisco.com>
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

On 8/5/2010 2:33 AM, Roland Dreier wrote:

Hi Roland,

>
> Here are a few topics I'm tracking that are not ready in time for the
> 2.6.36 window and will need to wait for 2.6.37 at least:
>
>  - XRC.  While I think we made significant progress here, the fact is
>    that this is not ready to merge at the beginning of the merge
>    window, and so we'll need to keep working on it and wait for the
>    next merge window.  I think this is just blocked on me at the
>    moment.
Jack did all the changes you asked for and submitting the V3 patches on 2010/05/19, 
which was long enough before the window.
What is the reason it will not be part of 2.6.36 kernel?

>
>  - IBoE.  Same as XRC; we made significant progress (and I opened an
>    iboe branch to track this), and I think we have finally gotten the
>    user-kernel interface nailed down yet, but it's just too late.
Eli sent the user space patch that was the last technical debate last week. 
He will also send a new patch-set in day or two.
This feature was under a lot of technical review from the community.
Please consider including it in 2.6.36 after all.
 
In general - none of our new features going to be included and I wish to understand the reason behind it (I hope it's not personal :-)

regards
Tziporet

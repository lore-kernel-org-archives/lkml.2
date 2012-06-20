Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab2FTRSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:18:17 -0400
Received: from node140.e-blokos.com ([67.205.80.140]:35681 "EHLO
	node140.e-blokos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab2FTRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:18:14 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2012 13:18:14 EDT
Message-ID: <5839DCEA739B481B8C28EF3441D255EF@e1705>
From: "Madovsky" <infos@madovsky.org>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>, <linux-kernel@vger.kernel.org>
References: <loom.20120620T164714-725@post.gmane.org> <804857E1F29AAC47BF68C404FC60A1842846965C@ORSMSX102.amr.corp.intel.com>
Subject: Re: e1000e, 3.4.1, , jumbo frames are not working
Date: Wed, 20 Jun 2012 12:55:33 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok thanks Bruce

----- Original Message ----- 
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: "madovsky" <infos@madovsky.org>; <linux-kernel@vger.kernel.org>
Sent: Wednesday, June 20, 2012 12:45 PM
Subject: RE: e1000e, 3.4.1, , jumbo frames are not working


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of madovsky
> Sent: Wednesday, June 20, 2012 7:49 AM
> To: linux-kernel@vger.kernel.org
> Subject: RE: e1000e, 3.4.1, , jumbo frames are not working
> 
> it's the same on kernel 3.4.3.
> I can't activate jumbo frames
> my mobo is S5000PAL

This is already known and discussed on previous threads.  If you look at
the system log file you will see a message from the driver which states
"Jumbo frames cannot be enabled  when both receive checksum offload and
receive hashing are enabled.  Disable one of the receive offload features
before enabling jumbos."  A patch that removes this incompatibility is
currently in test here at Intel and should be passed upstream soon.

Thanks,
Bruce.

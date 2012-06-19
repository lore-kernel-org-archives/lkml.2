Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab2FSOcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:32:45 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:50010 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2FSOco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:32:44 -0400
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <201206182229.32055.rjw@sisk.pl> <8c993882-5949-471d-a15c-0c91d3d2deb9@email.android.com> <201206182328.19811.rjw@sisk.pl> <1340071797.1666.24.camel@shrek.rexursive.com> <20120619142111.GA4151@x1.osrc.amd.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120619142111.GA4151@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
Date: Wed, 20 Jun 2012 00:32:38 +1000
To: Borislav Petkov <bp@alien8.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <eac3880d-fee8-4006-ba92-8ab55f8d3ab2@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:

>which, on the whole, is nice and compact and still contains the whole
>info.

Yeah, that was the deal with the dots too. But, Rafael suggested we do lines (and I see his point). This way any other lines printed in the meantime (I have seen that happen) will also print properly. Ditto that last line - 100% is still not quite finished. :-)

-- 
Bojan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2FSVcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:32:43 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:47639 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab2FSVcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:32:41 -0400
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <20120619142111.GA4151@x1.osrc.amd.com> <eac3880d-fee8-4006-ba92-8ab55f8d3ab2@email.android.com> <201206192223.07326.rjw@sisk.pl>
User-Agent: K-9 Mail for Android
In-Reply-To: <201206192223.07326.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
Date: Wed, 20 Jun 2012 07:32:35 +1000
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <f138f679-8a00-4173-9f5f-f7ea1e4a4579@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>I'd use a slightly different status line, though.  What about:
>
>"PM: Image saving progress: %d%%"
>
>Then, if something is printed in between those lines, it'll still be
>clear
>what they mean.

Yeah, will change and send to you with signed off.

-- 
Bojan

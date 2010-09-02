Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0IBIfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:35:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0IBIfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=tJrd6ca3IS9V8r+DL/xbIZrYMTUZz9kZCPy8yL4L2kiVWSGWKujwVYPMH+x4DxJL7Q
         wMRpss9BCy+H7nABFQNqzkp2JoreHdtP8/d++S6L4yWmEFImU3hs1kAVO427Nc+Ysooo
         cwIblxn3VnQXJM9Q2Jx50iTB90INageJJYUNw=
MIME-Version: 1.0
In-Reply-To: <x49fwxtqsh8.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
	<x49fwxtqsh8.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 2 Sep 2010 09:34:59 +0100
Message-ID: <AANLkTikGYEuCE2-TaKwANwoCFEjVNL4KZa1AhJ2woGud@mail.gmail.com>
Subject: Re: I/O scheduler deadlocks on Xen virtual block devices
From: Doug Neal <dneallkml@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Did you try these different I/O schedulers in the domU or on the dom0?
> Does switching I/O schedulers in either place make the problem go away
> when it happens?
>

In the domU, and the bug was present in all cases. The dom0 was using
cfq. I'll run the tests again using each scheduler in the dom0 with
domU set to noop and report back.

Thanks,

Doug

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0GWRZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:25:20 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:49008 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754947Ab0GWRZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:25:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gXAm+xhS3U4apRpGhJnSr88kGYKQsIkhvk8yfN91bfdbRChyya2DGJLMGmN9Qvm+gcnxbvoBOXTQm5DI1Lovpgq3qMDID6fK5z5cQKZH6j+RAlK501IFF2ubcDo+rvj2;
Date: Fri, 23 Jul 2010 10:25:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Enrico Bandiello" <enban@postal.uv.es>
Subject: Re: [Bug #16307] i915 in kernel 2.6.35-rc3, high number of wakeups
Message-ID: <20100723102532.6bfade32@virtuousgeek.org>
In-Reply-To: <tneGvaw1wLL.A.mXB.p3XSMB@chimera>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera>
	<tneGvaw1wLL.A.mXB.p3XSMB@chimera>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 13:47:31 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16307
> Subject		: i915 in kernel 2.6.35-rc3, high number of wakeups
> Submitter	: Enrico Bandiello <enban@postal.uv.es>
> Date		: 2010-06-26 16:57 (28 days old)
> Message-ID	: <4C26317A.5070309@postal.uv.es>
> References	: http://marc.info/?l=linux-kernel&m=127757403404259&w=2

Just updated the bug for this one.  Enrico, you say this behavior is
recent.  Can you bisect between 2.6.34 and when the problem started?

-- 
Jesse Barnes, Intel Open Source Technology Center

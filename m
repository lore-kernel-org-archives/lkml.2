Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab0KINzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:55:11 -0500
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:54986 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448Ab0KINzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:55:08 -0500
Subject: Re: [Resend][PATCH 2/2] Drivers: block: aoe: Makefile: replace the use of <module>-objs with <module>-y
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <20101109121113.956cc6e5.sfr@canb.auug.org.au>
Date: Tue, 9 Nov 2010 08:54:55 -0500
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "sage@newdream.net" <sage@newdream.net>,
        "yehuda@hq.newdream.net" <yehuda@hq.newdream.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tracey Dent <tdent48227@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <767A0825-0AC8-4B95-BE03-41027F9BC1E6@coraid.com>
References: <1289069918-2085-1-git-send-email-tdent48227@gmail.com> <1289069918-2085-2-git-send-email-tdent48227@gmail.com> <EDA33B3B-F9C9-4C45-B20D-C985DFC95C2F@coraid.com> <20101108130543.1188a63f.akpm@linux-foundation.org> <20101109121113.956cc6e5.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 8, 2010, at 8:11 PM, Stephen Rothwell wrote:
...
> I have a quilt series in linux-next called aoe that has not been updated
> since Nov, 2009.  Can I assume that it is defunct and remove it?  Or will
> you be using it again?

You can remove it, thanks.  When I created it, I had the
misunderstanding that I was supposed to push through
linux-next into Linus's tree.  But patches still just go through
Andrew or Jens.

The aoe changes usually aren't invasive enough to benefit
from being available in linux-next, I think.

-- 
  Ed Cashin
  ecashin@coraid.com


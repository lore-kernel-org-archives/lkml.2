Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab1ENELw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 00:11:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1ENELs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 00:11:48 -0400
Date: Sat, 14 May 2011 06:11:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110514041146.GT6008@one.firstfloor.org>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com> <20110513124523.GM13984@redhat.com> <BANLkTimoqYZMs15H8wRqEEe=UyBJtAwipw@mail.gmail.com> <20110513135154.GB31888@redhat.com> <BANLkTiktuq3vMXKOdChm03SF6V4c2GhDVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTiktuq3vMXKOdChm03SF6V4c2GhDVw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IMHO, Linux is not X, so Linux kernel will not push all policy to user
> space.  And for fatal hardware error processing, there may be no
> opportunity for user space to run.

s/may/is/

Everyone who claims something else doesn't like your data :-)

-Andi

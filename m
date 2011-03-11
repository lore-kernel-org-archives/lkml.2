Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1CKH7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:59:53 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:49250 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab1CKH7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:59:51 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 11 Mar 2011 09:02:43 +0100
To: Wang Lei <f3d27b@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Message-ID: <20110311080243.GA1640@polaris.bitmath.org>
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
 <20110310213340.GA1821@polaris.bitmath.org>
 <4d796f2c.20f98e0a.3266.fffff4e2@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d796f2c.20f98e0a.3266.fffff4e2@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxxGE-0006Ur-7T.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PxxGE-0006Ur-7T 042143a3dac80f6247638f5d6e67082f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've confirmed the commit that caused the problem and sent a mail.
> 
> I don't know if these two problem are related, because i ran your
> command but there is no `/sys/module/*/srcversion' in my system. I think
> this is because of some configs i didn't enable. But I'll wait to see if
> I've provided enough information to help your hackers fix it.

Hm, looks like a different problem, then. Mine stops at

commit b7bd182176960fdd139486cadb9962b39f8a2b50
Author: Michal Marek <mmarek@suse.cz>

    fixdep: Do not record dependency on the source file itself

This looks like a build change, so perhaps a symptom rather than the
actual problem. Nevertheless, that's where it stops.

Thanks,
Henrik

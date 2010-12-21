Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0LUXai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:30:38 -0500
Received: from seehuhn.de ([80.68.93.199]:33986 "EHLO seehuhn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab0LUXah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:30:37 -0500
Date: Tue, 21 Dec 2010 23:30:30 +0000
From: Jochen Voss <voss@seehuhn.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: Linux 2.6.37-rc7
Message-ID: <20101221233022.GA9188@seehuhn.de>
References: <AANLkTi=H7PHrLthxsM6x7bKPVHcn7bmH--7ehwJo1wLB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=H7PHrLthxsM6x7bKPVHcn7bmH--7ehwJo1wLB@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

On Tue, Dec 21, 2010 at 11:52:17AM -0800, Linus Torvalds wrote:
> I'm still nervous about some of the regression reports for intel
> graphics, so please keep testing and reporting. This is the last -rc
> before xmas (or whatever your holiday may be), so now you all have a
> few free days when you have nothing better to do than test out an -rc
> release, right?

For reference, the regression I reported yesterday
(message id "20101220140615.GA3035@automatix",
http://www.spinics.net/lists/kernel/msg1126718.html
on the web) is still present: -rc7 only shows a blank
screen on my system, -rc7 with 541cc966 reverted works
without problems.

I hope this helps,
Jochen
-- 
http://seehuhn.de/

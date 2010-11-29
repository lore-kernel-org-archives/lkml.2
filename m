Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0K2KBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:01:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37288 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0K2KBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:01:48 -0500
From: Andi Kleen <andi@firstfloor.org>
To: microcai@fedoraproject.org
Cc: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
References: <1290941875.13526.15.camel@cai.gentoo>
Date: Mon, 29 Nov 2010 11:01:46 +0100
In-Reply-To: <1290941875.13526.15.camel@cai.gentoo>
	(microcai@fedoraproject.org's message of "Sun, 28 Nov 2010 18:57:55
	+0800")
Message-ID: <87mxosla7p.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcai <microcai@fedoraproject.org> writes:

> 	I'm implementing the UNICODE font of the framebuffer console, (see
> http://lkml.org/lkml/2010/11/26/50 in case you do not got my email). But
> current vt code is too bugy, too many direct assumes about vt buffer,
> This makes me so hard to hack.  There is TODO telling me to add UNICODE
> support, but no room for such code, that's why my patch is so tricky.
>
> 	And the code itself, if you'll excuse me, it isn't as beautiful as rest
> of the kernel.
> 	So, it really really need a clean rewrite.I'm ganna take is hard job.	
> 	And, please tell me if is worth to do so.

To be honest I have doubts its worth it. This was discussed years and
years ago and the conclusion back then that people who need unicode
fonts should use them in X or another graphical console environment
(there are plenty to chose from these days). Has this changed?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

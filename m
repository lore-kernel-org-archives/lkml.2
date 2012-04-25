Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab2DYLJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:09:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DYLJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:09:42 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=X6OtPzvZJdgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=7I7NCgmvS7_8LW7REc0A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335352180.28106.151.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2] ktest.pl: Fix combined usage of BISECT_REVERSE and
 BISECT_SKIP
From: Steven Rostedt <rostedt@goodmis.org>
To: Russ Dill <Russ.Dill@ti.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 25 Apr 2012 07:09:40 -0400
In-Reply-To: <4F9776B4.60001@ti.com>
References: <1335222539-31546-1-git-send-email-Russ.Dill@ti.com>
	  <1335222909-14191-1-git-send-email-Russ.Dill@ti.com>
	 <1335228915.28106.129.camel@gandalf.stny.rr.com> <4F9776B4.60001@ti.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 20:59 -0700, Russ Dill wrote:

> BTW, I can across an additional problem that I'm not sure how to solve.
> I'm using PRE_BUILD and POST_BUILD to apply a patch during a bisect. As
> soon as the bisect hits a tree where the patch applies, the module
> tar-up fails. The kernel version (and module path) has a '-dirty' but
> ktest.pl is calling its get_version after POST_BUILD when the tree is clean.

I'm aware of this issue, as I hit this bug myself. I have some patches
that fix it, but they are currently ugly. I'm working on a better fix.

Thanks,

-- Steve



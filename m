Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1EMCrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 22:47:37 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54131 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1EMCrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 22:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=DvtF/fCfMIXgIzjXvMX9Kve1A/D7cgCuQ8syc4a/l9S3+1cSG6uMGVXMwTlHBpZd42
         HD79t6nZSRZHhWpUZePDfPsTsGQEeWd3X77y1SBIGLoZbtL8A+t8jAWJJMGryaXmbTvC
         Qiu9ddfiWCrmiEiBblR5clBBF6Qwbjeg514xQ=
MIME-Version: 1.0
In-Reply-To: <20110426105823.F368.A69D9226@jp.fujitsu.com>
References: <20110426105045.F359.A69D9226@jp.fujitsu.com> <20110426105518.F35D.A69D9226@jp.fujitsu.com>
 <20110426105823.F368.A69D9226@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 12 May 2011 22:47:15 -0400
Message-ID: <BANLkTikod_hEANuEBVENeDXRQwvhjCGsvw@mail.gmail.com>
Subject: Re: (resend) [PATCH 3/4] blackfin: don't touch task->cpus_allowed directly
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 21:56, KOSAKI Motohiro wrote:
> Every callter (except kthread_bind) should use proper
> set_cpus_allowed_ptr() APIs.

ive merged this, thanks
-mike

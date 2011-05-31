Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab1EaAiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1EaAiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:38:08 -0400
Subject: Re: [PATCH] depmod: Handle X.Y kernel versions
From: Jon Masters <jcm@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle McMartin <kmcmartin@redhat.com>
In-Reply-To: <4DE3AF93.40405@suse.cz>
References: <1306763923-11892-1-git-send-email-mmarek@suse.cz>
	 <BANLkTinU9DoY4gUXK2kaoUiNvbG905-ngQ@mail.gmail.com>
	 <4DE3AF93.40405@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Mon, 30 May 2011 20:46:14 -0400
Message-ID: <1306802774.4987.18.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 16:54 +0200, Michal Marek wrote:
> On 30.5.2011 16:43, Kay Sievers wrote:
> > On Mon, May 30, 2011 at 15:58, Michal Marek<mmarek@suse.cz>  wrote:
> >> What a stupid check.
> >
> > Maybe get rid of the entire check?

> Why not. It tries to distinguish between
> depmod da.da.da (kernel version)
> and
> depmod /path/to/module.ko ... (only generate tables for listed modules)
> 
> Either we can check for slashes in the second use case, or just drop 
> support for it.

Well, for tonight I'm just killing off the 3 number check and taking the
patch from Michal that matches on two numbers (thanks Kyle for sending
another version earlier in the day too but we don't need to be quite so
cleaver, just distinguish between a version and module path passed in).
I'll post a separate email announcing a new release with this fix.

I know it's a silly check, but it's probably not the only silly check
out there in the wild world yonder. Part of me thinks it'd be better to
just keep it as 3.0.0 so that we don't have an ongoing series of script
explosions. Another part of me is just so excited to finally see a 3.0
release that I've forgotten about 2.6 entirely (that's /so/ last week).

Jon.



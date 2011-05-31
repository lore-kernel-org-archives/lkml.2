Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab1EaFxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 01:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1EaFxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 01:53:31 -0400
Subject: Re: [PATCH] depmod: Handle X.Y kernel versions
From: Jon Masters <jcm@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle McMartin <kmcmartin@redhat.com>
In-Reply-To: <1306802774.4987.18.camel@constitution.bos.jonmasters.org>
References: <1306763923-11892-1-git-send-email-mmarek@suse.cz>
	 <BANLkTinU9DoY4gUXK2kaoUiNvbG905-ngQ@mail.gmail.com>
	 <4DE3AF93.40405@suse.cz>
	 <1306802774.4987.18.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat, Inc.
Date: Tue, 31 May 2011 02:02:06 -0400
Message-ID: <1306821726.4987.37.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 20:46 -0400, Jon Masters wrote:

> Well, for tonight I'm just killing off the 3 number check and taking the
> patch from Michal that matches on two numbers (thanks Kyle for sending
> another version earlier in the day too but we don't need to be quite so
> cleaver, just distinguish between a version and module path passed in).
> I'll post a separate email announcing a new release with this fix.

FYI, I pushed 3.13 up to hera earlier but it's not yet syncing. I'll
have updates out for Fedora (rawhide) and F15 testing by the morning.

Jon.



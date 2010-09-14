Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0INTeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:34:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0INTeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:34:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: pageexec@freemail.hu
X-Fcc: ~/Mail/linus
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        Brad Spengler <spender@grsecurity.net>, Eugene Teo <eugene@redhat.com>
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
In-Reply-To: pageexec@freemail.hu's message of  Saturday, 11 September 2010 15:30:38 +0200 <4C8B847E.4988.3D86C35@pageexec.freemail.hu>
References: <20100827220258.GF4703@outflux.net>
	<pageexec@freemail.hu's message of  Wednesday, 8 September 2010 10:29:58 +0200 <4C874986.23581.F34F4BD@pageexec.freemail.hu>
	<20100910085915.8CC23405D5@magilla.sf.frob.com>
	<4C8B847E.4988.3D86C35@pageexec.freemail.hu>
Emacs: a real time environment for simulating molasses-based life forms.
Message-Id: <20100914193331.DB434403E8@magilla.sf.frob.com>
Date: Tue, 14 Sep 2010 12:33:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Readability and obviousness are in the eye of the beholder.   
Linus has merged my patches, so this crash is now fixed.  
As I said before, you should by all means send further clean-up
patches if you think they are improvements.

I have no special interest in this area.  I gave my opinions and
advice because I was CC'd, and then submitted some patches myself
because I was asked to.  I can't really keep track of all the
formalities.  The CC list on my submissions represented the set
of people I knew to be involved in the discussion.  I'm sorry if
you felt slighted.  I just pay attention to the code, not the
personalities.  The most reliable way to make sure your name is
associated with a change is to submit patches yourself in a form
that Linus wants to merge.


Thanks,
Roland

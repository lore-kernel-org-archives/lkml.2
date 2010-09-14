Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab0INWgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:36:06 -0400
Received: from r00tworld.com ([212.85.137.21]:38182 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0INWgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:36:05 -0400
From: pageexec@freemail.hu
To: Roland McGrath <roland@redhat.com>
Date: Wed, 15 Sep 2010 00:35:07 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Reply-to: pageexec@freemail.hu
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        Brad Spengler <spender@grsecurity.net>, Eugene Teo <eugene@redhat.com>
Message-ID: <4C8FF89B.24404.153DFD7D@pageexec.freemail.hu>
In-reply-to: <20100914193331.DB434403E8@magilla.sf.frob.com>
References: <20100827220258.GF4703@outflux.net>, <pageexec@freemail.hu's message of  Saturday, 11 September 2010 15:30:38 +0200 <4C8B847E.4988.3D86C35@pageexec.freemail.hu>>, <20100914193331.DB434403E8@magilla.sf.frob.com>
X-mailer: Pegasus Mail for Windows (4.52)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 15 Sep 2010 00:34:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Sep 2010 at 12:33, Roland McGrath wrote:

> I have no special interest in this area.  I gave my opinions and
> advice because I was CC'd, and then submitted some patches myself
> because I was asked to.  I can't really keep track of all the
> formalities.  The CC list on my submissions represented the set
> of people I knew to be involved in the discussion.  I'm sorry if
> you felt slighted.  I just pay attention to the code, not the
> personalities.

i was referring to Brad, since he reported this (and the wireless
heap infoleak which he also wasn't credited for). anyway, we won't be
submitting any further vulnerability reports, so no need to worry about
any 'formalities' in the future.

>  The most reliable way to make sure your name is
> associated with a change is to submit patches yourself in a form
> that Linus wants to merge.

his conditions are unacceptable and therefore it's not going to happen.


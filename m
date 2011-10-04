Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437Ab1JDTA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:00:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:41694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDTAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:00:55 -0400
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: quilt-dev <quilt-dev@nongnu.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Kacur <jkacur@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Date: Tue, 04 Oct 2011 20:59:55 +0200
In-Reply-To: <1317750395.18063.11.camel@gandalf.stny.rr.com>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317754795.32543.32.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 13:46 -0400, Steven Rostedt wrote:
> Added the quilt mail option --pass to allow the user to enter a
> passphrase and sign their email patches.
> 
> Thanks to Peter Zijlstra for recommending --use-agent to solve the
> issues of both the passphrase in unlocked memory, and typing something
> wrong. 

How about another option that also allows you to pick they key used for
signing things?

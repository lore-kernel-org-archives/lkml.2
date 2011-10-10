Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab1JJPhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:37:23 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40236 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1JJPhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:37:21 -0400
MIME-Version: 1.0
In-Reply-To: <1318260925.7904.89.camel@gandalf.stny.rr.com>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	<20111004180237.GA15087@suse.de>
	<4E8B4BEC.5030708@zytor.com>
	<1317757101.18063.24.camel@gandalf.stny.rr.com>
	<4E8B6172.2050006@zytor.com>
	<1317757696.18063.28.camel@gandalf.stny.rr.com>
	<1317769149.1662.28.camel@schurl.linbit>
	<1318260925.7904.89.camel@gandalf.stny.rr.com>
Date: Mon, 10 Oct 2011 11:37:20 -0400
Message-ID: <CA+5PVA5_rE3fMWEKaYC_2E3VofrHkwNDDHviUXO+RYkvEYuNVA@mail.gmail.com>
Subject: Re: [Quilt-dev] [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Josh Boyer <jwboyer@gmail.com>
To: quilt-dev@nongnu.org
Cc: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 11:35 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-10-05 at 00:58 +0200, Andreas Gruenbacher wrote:
>
>> Yes, please.  Also please use Getopt::Long in the Perl script, and
>> send a patch relative to the quilt repo. I unfortunately can't help
>> with how to beat gpg into behaving right.
>
> Where do I find the official quilt repo? Doing google searches only
> leads me to knitting sites. Which is actually quite helpful as the
> winter temperatures are coming around the corner.

http://savannah.nongnu.org/git/?group=quilt

josh

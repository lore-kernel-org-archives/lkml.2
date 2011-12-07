Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab1LGTv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 14:51:27 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:36393 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab1LGTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 14:51:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20191.49202.793643.397028@quad.stoffel.home>
Date: Wed, 7 Dec 2011 14:36:18 -0500
From: "John Stoffel" <john@stoffel.org>
To: Colin Walters <walters@verbum.org>
Cc: LKML <linux-kernel@vger.kernel.org>, morgan@kernel.org, serue@us.ibm.com,
        dhowells@redhat.com, kzak@redhat.com
Subject: Re: chroot(2) and bind mounts as non-root
In-Reply-To: <1323280461.10724.13.camel@lenny>
References: <1323280461.10724.13.camel@lenny>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin Walters <walters@verbum.org> writes:

Colin> I've recently been doing some work in software compilation, and it'd be
Colin> really handy if I could call chroot(2) as a non-root user.  The reason
Colin> to chroot is to help avoid "host contamination" - I can set up a build
Colin> root and then chroot in.  The reason to do it as non-root is, well,
Colin> requiring root to build software sucks for multiple obvious reasons.

What's wrong with using 'fakeroot' or tools like that instead?  Why
does the Kernel need to be involved like this?  I'm not against your
proposal so much, as trying to understand how compiling a bunch of
source requires this change.

John

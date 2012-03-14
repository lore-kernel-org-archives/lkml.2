Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546Ab2CNVif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:38:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab2CNVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:38:34 -0400
Date: Wed, 14 Mar 2012 14:38:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Ledford <dledford@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>,
        "\"Eric W. Biederman\" (commit_signer:2/9=22%)" 
	<ebiederm@xmission.com>,
        "Joe Korty (commit_signer:2/9=22%)" <joe.korty@ccur.com>,
        "David Howells (commit_signer:2/9=22%)" <dhowells@redhat.com>
Subject: Re: [resend][PATCH 1/3] mqueue: revert bump up DFLT_*MAX
Message-Id: <20120314143832.286b497e.akpm@linux-foundation.org>
In-Reply-To: <4F610D81.3020300@redhat.com>
References: <1323470163-8723-1-git-send-email-kosaki.motohiro@gmail.com>
	<4EEE3124.7070605@gmail.com>
	<20111218103836.258eedb8.akpm@linux-foundation.org>
	<4F610D81.3020300@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 17:28:33 -0400
Doug Ledford <dledford@redhat.com> wrote:

> This has obviously fallen through the cracks.

It sure has.  Please dig out whatever is the currently favored
patchset, refresh, retest and resend, with changelogging which fully
covers the reasoning and decision process?

> so that if there are any apps out there that have been coded to expect
> this behavior, then there is a workaround path for them until they get
> coded

We'll be especially interested in the implications of this part.


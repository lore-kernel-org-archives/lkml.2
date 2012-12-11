Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2LKSfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:35:34 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41140 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2LKSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:35:28 -0500
MIME-Version: 1.0
In-Reply-To: <1355249884.2356.108.camel@falcor>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	<1355249884.2356.108.camel@falcor>
Date: Tue, 11 Dec 2012 13:35:26 -0500
Message-ID: <CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Eric Paris <eparis@parisplace.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 1:18 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> The appraisal policy is based on the object metadata, such as the uid,
> so the result is static and can be cached.  The measurement policy, on
> the other hand, is normally based on the subject (eg. who is
> reading/executing) the file.  Knowledge of whether the file has been
> measured is cached in the iint, but unlike the appraisal policy, not
> whether it needs to be measured.  Having the flag on a per inode basis,
> doesn't really help.

Can you try again?  Even I can't parse this.  Not sure what to tell
you to try again, maybe give us a summary at a high level again and
then why this patch is specifically necessary?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2LKOIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 09:08:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56533 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2LKOIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 09:08:47 -0500
Message-ID: <1355234914.2356.85.camel@falcor>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>
Date: Tue, 11 Dec 2012 09:08:34 -0500
In-Reply-To: <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	 <CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	 <CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121114-7182-0000-0000-000003B25383
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 14:51 +0200, Kasatkin, Dmitry wrote:

> >> Here is two patches for policy search speedup.
> >>
> >> First patch adds additional features flags to superblock.
> >> Second - implementation for IMA.
> >>
> >> Two months ago I was asking about it on mailing lists.
> >> Suggestion was not to use s_flags, but e.g. s_feature_flags.
> >>
> >> Any objections about such approach?

First of all my appologies for not responding earlier.  Based on the
previous discussion https://lkml.org/lkml/2012/9/19/9, this looks like
the right direction.  Specific comments will be posted on the individual
patches.

thanks,

Mimi


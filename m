Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KJExl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 23:53:41 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43112 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0KJExj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 23:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=x+QazzcMtHOBSJm5dZikaZTWPgTC9J6+VlkNZzwEL9feeIpSPP2PxqtDS8YhPiYryu
         A8bY9qi3xh/Mw0qvX6Mx+r9AgD+o8ciLkyGXZBjhoEPtujc/vpPGOjC7n7Op/eWXALzy
         0V6eerIGe8UP5FUYYYjFBuilGy2L0pOF3MjqQ=
MIME-Version: 1.0
In-Reply-To: <20101109224450.GB21992@kroah.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com>
	<20101109224450.GB21992@kroah.com>
Date: Wed, 10 Nov 2010 10:53:37 +0600
Message-ID: <AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 4:44 AM, Greg KH <greg@kroah.com> wrote:
>
> If it's really not used then why would marking it inline help out any?
> Shouldn't we just delete the function instead?
>
As far as I can see, its been called recursively and also from
sysfs_add_one. Am I missing anything?


thanks
rakib

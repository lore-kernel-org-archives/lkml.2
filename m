Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2FTGoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:44:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50694 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2FTGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:44:11 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.103.112]
In-Reply-To: <20120620163130.b7bbb33fbed65837bf386f59@canb.auug.org.au>
References: <20120620163130.b7bbb33fbed65837bf386f59@canb.auug.org.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 20 Jun 2012 09:43:50 +0300
Message-ID: <CAK=WgbbmCeF+oxnR+Hs4JfDBxFc34oqj=dkcOdtrz7O732=oyA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the remoteproc tree with Linus' tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?=22Sjur_Br=E6ndeland=22?= 
	<sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Jun 20, 2012 at 9:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Ohad,
>
> Today's linux-next merge of the remoteproc tree got conflicts in
> drivers/remoteproc/remoteproc_core.c between commits e981f6d41acd
> ("remoteproc: fix print format warnings") and 30338cf09f82 ("remoteproc:
> fix missing fault indication in error-path") from Linus' tree and commits
> 7826bf782364 ("remoteproc: Pass struct fw to load_segments and
> find_rsc_table"), a933c9f8ef8a ("remoteproc: Add function
> rproc_get_boot_addr") and 32d46fe7f468 ("remoteproc: Move Elf related
> functions to separate file") from the remoteproc tree.
>
> I fixed them up (see below) and can carry the fixes as necessary.

Looks good, thanks!

Ohad.

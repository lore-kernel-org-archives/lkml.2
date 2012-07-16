Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2GPGNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:13:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39026 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2GPGNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:13:05 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <20120716160345.d5e88e6e53483a9c08ba3a75@canb.auug.org.au>
References: <20120716160345.d5e88e6e53483a9c08ba3a75@canb.auug.org.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 16 Jul 2012 09:12:44 +0300
Message-ID: <CAK=WgbaAiQPA+q40-4ej=EZqOfN+kAMwK5-7hg4MdvdwJ+febw@mail.gmail.com>
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

On Mon, Jul 16, 2012 at 9:03 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Ohad,
>
> Today's linux-next merge of the remoteproc tree got a conflict in
> drivers/remoteproc/remoteproc_core.c between commits e981f6d41acd
> ("remoteproc: fix print format warnings") and 30338cf09f82 ("remoteproc:
> fix missing fault indication in error-path") from Linus' tree and commits
> bd4849848773 ("remoteproc: Pass struct fw to load_segments and
> find_rsc_table") and 72854fb042b1 ("remoteproc: Move Elf related
> functions to separate file") from the remoteproc tree.
>
> I fixed them up (see below) and can carry the fixes as necessary.

Looks great, thanks a lot!

Ohad.

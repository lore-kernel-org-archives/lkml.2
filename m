Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1BBLwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:52:40 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45683 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1BBLwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:52:39 -0500
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org
In-reply-to: <20110201175452.GB518@core.coreip.homeip.net> (message from
	Dmitry Torokhov on Tue, 1 Feb 2011 09:54:52 -0800)
Subject: Re: 2.6.38-rc3: FUSE (sshfs) hangs under load
References: <20110201175452.GB518@core.coreip.homeip.net>
Message-Id: <E1PkbGG-0005Rf-QL@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Feb 2011 12:52:36 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011, Dmitry Torokhov wrote:
> Hi,
> 
> After installing 2.6.38-rc3 (plus a few input patches) sshfs started to
> misbehave on me under load. It starts off fine but when I try to compile
> a few modules against kernel sources residing on the other box the
> processes go into 'D' state and just sit there doing nothing.

Can you please post a stack trace from SysRq-T?

Thanks,
Miklos

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1AQJfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 04:35:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab1AQJfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 04:35:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201101170041.p0H0ffFE086481@www262.sakura.ne.jp>
References: <201101170041.p0H0ffFE086481@www262.sakura.ne.jp> <alpine.LNX.2.00.1101132100190.11347@swampdragon.chaosbits.net> <1295011682.7804.2.camel@localhost.localdomain> <201101142245.GGI86457.OQFFFMOtVOHJLS@I-love.SAKURA.ne.jp> <201101142307.EHC56742.FVtMFHOOFSQJOL@I-love.SAKURA.ne.jp> <alpine.LNX.2.00.1101161504050.8049@swampdragon.chaosbits.net> <201101170039.p0H0d1f5085735@www262.sakura.ne.jp> 
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: dhowells@redhat.com, safford@watson.ibm.com, safford@us.ibm.com,
        jj@chaosbits.net, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] trusted-keys: check for NULL before using it
Date: Mon, 17 Jan 2011 09:34:55 +0000
Message-ID: <3575.1295256895@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> From 8118c3d0d6f2b291d56e2f4475f2aa5156299cf3 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 17 Jan 2011 09:25:34 +0900
> Subject: [PATCH 2/3] trusted-keys: check for NULL before using it
> 
> TSS_rawhmac() checks for data != NULL before using it.
> We should do the same thing for TSS_authhmac().
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Acked-by: David Howells <dhowells@redhat.com>

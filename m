Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1BVGfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:35:17 -0500
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:49996
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1BVGfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:35:15 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 01:35:15 EST
References: <20110222162206.c3fb0636.sfr@canb.auug.org.au>
User-Agent: K-9 Mail for Android
In-Reply-To: <20110222162206.c3fb0636.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: build failure after merge of the drivers-x86 tree
From: Mattia Dongili <malattia@linux.it>
Date: Tue, 22 Feb 2011 15:26:53 +0900
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <a8c6f32c-ccb5-4f65-b537-8bd1c11f7336@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>Hi Matthew,
>
>After merging the drivers-x86 tree, today's linux-next build (x86_64
>allmodconfig) failed like this:

Apologies, I didn't test my code with
DEBUG_LOCK_ALLOC=y.
I'll send a fix in as soon as I get around a usable network
connection.

-- 
mattia
:wq

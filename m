Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1EFTjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:39:21 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:53762 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab1EFTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:39:20 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lk2s7oFj0=
X-RZG-CLASS-ID: mo00
Date: Fri, 6 May 2011 21:39:16 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] add hook to read_from_oldmem() to check for non-ram pages
Message-ID: <20110506193916.GA26129@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
 <20110503190806.GA12485@aepfle.de>
 <20110505142551.b4d2d95a.akpm@linux-foundation.org>
 <20110506105545.GA16945@aepfle.de>
 <20110506123019.80461d5d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110506123019.80461d5d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, Andrew Morton wrote:

> So as your module will have a reference to vmcore.c's register and unregister
> functions, nothing needs to be done: the presence of the client module alone
> will pin the vmcore.c module.

I meant the other way around. Keep /proc/vmcore open and read from it,
then try to rmmod foo.ko which provides fn().

Olaf

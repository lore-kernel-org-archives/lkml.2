Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1IBFSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 01:18:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51692 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751731Ab1IBFSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 01:18:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/m2mQ9GqDmvveXdoY0Z+nYssuantQKK8gLOLzryU
	04B36+86Vcmhvw
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
From: Mike Galbraith <efault@gmx.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephenmcameron@gmail.com,
        thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
In-Reply-To: <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	 <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 07:18:36 +0200
Message-ID: <1314940716.6336.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 17:24 +0200, Eric Dumazet wrote:
> Stephen,
> 
> Current linux-3.1-rc4+ is a total disaster on my BL460c G6
> 
> 
> Few seconds after boot, I get "cmd_alloc returned NULL" messages
> or "hpsa 0000:0c:00.0: resetting device 0:0:0:0"

Bingo.

> Usually lot of files are corrupted, fsck needed, and full distro
> reinstall as well.

(I put tip-rt11 on a DL980 three times.. munched fs each time)


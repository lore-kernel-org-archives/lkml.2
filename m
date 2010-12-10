Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0LJOHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:07:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab0LJOG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:06:59 -0500
Date: Fri, 10 Dec 2010 15:06:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED] poll: fix a typo in comment
In-Reply-To: <20101210144111.C7B6.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.LNX.2.00.1012101506510.15140@pobox.suse.cz>
References: <AANLkTimUJ0mOkNe+ATAxDze_zHbWU8R1cJinEfX98Azw@mail.gmail.com> <1291913827-13558-1-git-send-email-namhyung@gmail.com> <20101210144111.C7B6.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, KOSAKI Motohiro wrote:

> > Convert duplicated sys_poll to select. As Kosaki suggests, sys_poll() and
> > sys_select() are now hidden by SYSCALL_DEFINEx() macros so it would be
> > better to use plain select/poll syscall name.
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> Thank you.
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab0HaL46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:56:58 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63382 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab0HaL44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:56:56 -0400
To: spender@grsecurity.net, solar@openwall.com
Cc: roland@redhat.com, kees.cook@canonical.com, linux-kernel@vger.kernel.org,
        oss-security@lists.openwall.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, oleg@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: [PATCH] exec argument expansion can inappropriately triggerOOM-killer
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20100827220258.GF4703@outflux.net>
	<20100830005648.431B7400D9@magilla.sf.frob.com>
	<20100830032331.GA22773@openwall.com>
	<20100830174920.GA25091@openwall.com>
	<20100830220847.GA24980@grsecurity.net>
In-Reply-To: <20100830220847.GA24980@grsecurity.net>
Message-Id: <201008312056.FAB26586.OOVFLJQOFFStMH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 31 Aug 2010 20:56:52 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brad Spengler wrote:
> The bug seems to have been introduced in 2.6.23, see:
> http://thread.gmane.org/gmane.linux.ports.hppa/752
> http://www.spinics.net/lists/linux-arch/msg01584.html
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg170491.html
> though I'm guessing the functionality was also backported to major 
> distros
As far as I know, RHEL >= 5.3 and Asianux >= 3.2 backported this functionality.

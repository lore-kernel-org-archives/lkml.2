Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab0GONGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 09:06:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48397 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab0GONGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 09:06:08 -0400
To: John Johansen <john.johansen@canonical.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-reply-to: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
	(message from John Johansen on Wed, 14 Jul 2010 17:43:28 -0700)
Subject: Re: [AppArmor #5 0/13] AppArmor security module
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Message-Id: <E1OZO8Z-0004a5-6S@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 Jul 2010 15:06:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010, John Johansen wrote:
> This is the fifth general posting of the newest version of the
> AppArmor security module it has been rewritten to use the security_path
> hooks instead of the previous vfs approach.  The current implementation
> is aimed at being as semantically close to previous versions of AppArmor
> as possible while using the existing LSM infrastructure.
> 
> Development is on going and
> improvements to file, capability, network, resource usage and ipc mediation
> are planned.
> 
> With this submission we believe AppArmor is ready for inclusion into
> the kernel.
> 
> _Issues NOT specifically addressed_
> * The d_namespace_path function still manually strips the " (deleted)"
>   string that __d_path appends.  A fix to __d_path is being pursued
>   independently of the AppArmor submission.

Latest posting on that front:

  http://lkml.org/lkml/2010/7/6/186

Thanks,
Miklos

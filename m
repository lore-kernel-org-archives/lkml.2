Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1GKMQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:16:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384Ab1GKMQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:16:50 -0400
Date: Mon, 11 Jul 2011 14:16:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] static should be at beginning of declaration
In-Reply-To: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107111416390.11049@pobox.suse.cz>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jul 2011, Jesper Juhl wrote:

> Here's a small series of patches that ake sure that the 'static' keywork 
> is at the beginning of declarations.
> 
> This gets rid of warnings like
>   warning: ¡static¢ is not at beginning of declaration
> when building with -Wold-style-declaration (and/or -Wextra which also
> enables it).
> 
> I've cleaned out a number of these in the past and this patch set 
> represents the last few remaining offenders in the entire tree.
> 
> All patches will be sent as replies to this mail.

Applied all of them, thanks Jesper.

-- 
Jiri Kosina
SUSE Labs

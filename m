Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1BET5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 14:57:41 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:47250 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1BET5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 14:57:40 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Valentin QUEQUET <valentin.quequet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GIT - cloning torvalds/linux-2.6.git repository trouble.
References: <AANLkTikiKagzJMh_xuOSzfA4c-qxOHhVeU2jhmbaDHji@mail.gmail.com>
X-Yow: Somewhere in suburban Honolulu, an unemployed bellhop is whipping up
 a batch of illegal psilocybin chop suey!!
Date: Sat, 05 Feb 2011 20:57:37 +0100
In-Reply-To: <AANLkTikiKagzJMh_xuOSzfA4c-qxOHhVeU2jhmbaDHji@mail.gmail.com>
	(Valentin QUEQUET's message of "Sat, 5 Feb 2011 18:17:57 +0000")
Message-ID: <m2oc6qntji.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valentin QUEQUET <valentin.quequet@gmail.com> writes:

> Now, I would like YOU to tell ME how I can checkout from the PACKs
> I've just downloaded.
>
> How may I populate the working directory , objects/xy/... , refs/... ,
> ... hierarchies to
>   make my (local) repository usable.

Once you put the downloaded *.pack and *.idx files on the
.git/objects/pack directory you should be able to just run `git fetch'
to complete your repository clone.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."

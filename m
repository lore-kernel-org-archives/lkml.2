Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab2DJTCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:02:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32870 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab2DJTCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:02:44 -0400
Message-ID: <4F8483CB.2010407@wwwdotorg.org>
Date: Tue, 10 Apr 2012 13:02:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 REPOST 5/5] pinctrl: tegra: Add complete device tree
 support
References: <1333553270-9040-1-git-send-email-swarren@wwwdotorg.org>	<1333553270-9040-5-git-send-email-swarren@wwwdotorg.org>	<CACRpkdZzET9OKC8xoXV_4OBAd9-EuhSh-OfG=es56bKidCoe9Q@mail.gmail.com>	<4F8457F9.7090309@wwwdotorg.org> <CACRpkdb=8ydKuX52cen8Y_iBzV+RwD61NCPrjQFXNgoO-=bc9Q@mail.gmail.com>
In-Reply-To: <CACRpkdb=8ydKuX52cen8Y_iBzV+RwD61NCPrjQFXNgoO-=bc9Q@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 12:31 PM, Linus Walleij wrote:
> On Tue, Apr 10, 2012 at 5:55 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> Is your pinctrl for-next branch considered "stable" (i.e. it won't ever
>> be rebased) at least up to commit a57be23 "pinctrl: tegra: Add complete
>> device tree support"?
> 
> Not quite yet, because I would expect the occasional -rc fix for
> -rc3 or so.

Hmm. Adding extra fixes wouldn't require you to rebase your branch would
it, just add extra changes on top of it?

>> If so, I'll use it as a base for the Tegra GPIO and pinmux rework branch.
> 
> Soon-ish that'd work...

Well, I guess I can base my branch on top of your current branch in
order to include the Tegra changes in linux-next. Once pinctrl is
stable, I can rebase on your stable commit and make sure I don't send
any pull requests until that's happened.

I'd really like to allow other people to pick up all the Tegra GPIO and
pinmux rework without having to work on top of my personal repo rather
than linux-next.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2CYKWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 06:22:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab2CYKWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 06:22:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL 02/09] ARM: global cleanups
Date: Sun, 25 Mar 2012 10:21:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
References: <1332626568-17812-1-git-send-email-arnd@arndb.de> <1332626568-17812-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1332626568-17812-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203251021.59187.arnd@arndb.de>
X-Provags-ID: V02:K0:eXvoUAb5bwZtycZM0yFhV6mcUR72icTQUzilH2f2qUd
 QMi5fQSbQXZXeuOyzNVxuEQ5+jyG8KNwcr3rc6i295o2UycoBY
 V4NU/QCttd6R6B2/Vbpcyg/55ymDVvMEr9ozYkGFekQfBkGafY
 GQKgCsiFnQxqRC7HBDGWdFBMMoYNrlEfhYD0K5dJEx/cW5Ncca
 B0ub23Go7J7S64Z5N/dSz6ad0fxwjn1XhfXz3vxnD2ncuQ1b9Q
 1sADQnT0QlGE5bxteqwN23gEne8vzmDyCxNIKa0xmeB90Q3Ub1
 RS1tikYR/1Hc3CAqYGPFX89J0VZAerL0c61GxNuk6+9WpLne8I
 lfd7DikigQBbgwNOOopM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 March 2012, Arnd Bergmann wrote:
> Quite a bit of code gets removed, and some stuff moved around, mostly
> the old samsung s3c24xx stuff. There should be no functional changes in
> this series otherwise. Some cleanups have dependencies on other arm-soc
> branches and will be sent in the second round.
> 
> The at91cap9 platform is removed and no longer listed in
> Documentation/feature-removal-schedule.txt, which conflicts with two
> new entries in that file.
> 
> arch/arm/plat-mxc/audmux-v1.c was removed, so the changes to its comments
> are meaningless now.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi Linus,

I've just had to update this tag again, the top commit is now 24d2e18,
this fixes a regression pointed out by Russell, which was introduced
in the cleanup branch but fixed in another commit that you have already
pulled. I've merged that branch into mine to keep this (more) bisectible.

	Arnd

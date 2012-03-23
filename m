Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab2CWXjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 19:39:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab2CWXjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 19:39:19 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: Alex Gershgorin <alexgershgorin@gmail.com>
Subject: Re: [PATCH] regulator: i.MX35-PDK Add regulator support
Date: Sat, 24 Mar 2012 09:43:06 +1100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Alex <alexg@meprolight.com>
References: <1332526267-3236-1-git-send-email-alexg@meprolight.com>
In-Reply-To: <1332526267-3236-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203240943.06346.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex, 

> Thanks for the patches.
> 
> v4 3/4 not directly applicable to Linux version 3.3,
> I installed it manually, you could check it out?

That patch series was based on mfd-2.6/for-next because it should be accepted 
in the kernel through the mfd tree. (look in the Maintainers file for the mfd 
git repo uri).

You could rebase it for 3.3 kernel for your own use. My guess is that the 
confilcts are in the Kconfig or Makefile so it won't be too much trouble.

Cheers,
Marc

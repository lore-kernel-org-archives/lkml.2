Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1F3Tqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:46:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54310 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1F3Tql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <1309461732-2875-2-git-send-email-jonas@southpole.se>
References: <201106281245.19457.arnd@arndb.de> <1309461732-2875-1-git-send-email-jonas@southpole.se>
 <1309461732-2875-2-git-send-email-jonas@southpole.se>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 30 Jun 2011 15:46:21 -0400
Message-ID: <BANLkTimAjC6mpFBqYhgjodANOed2mfbzrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] modules: make arch's use default loader hooks
To: Jonas Bonn <jonas@southpole.se>
Cc: rusty@rustcorp.com.au, arnd@ardnb.de, geert@linux-m68k.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 15:22, Jonas Bonn wrote:
>  arch/blackfin/kernel/module.c   |   21 -------------

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

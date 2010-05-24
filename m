Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0EXApw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:45:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60710 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0EXApv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:45:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
Date: Mon, 24 May 2010 02:46:54 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1274482015-30899-1-git-send-email-arve@android.com>
In-Reply-To: <1274482015-30899-1-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005240246.55043.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010, Arve Hjønnevåg wrote:
> This patch series adds a suspend-block api that provides the same
> functionality as the android wakelock api. This version adds a
> delay before suspending again if no suspend blockers were used
> during the last suspend attempt.

Patches [1-6/8] applied to suspend-2.6/linux-next

Thanks,
Rafael

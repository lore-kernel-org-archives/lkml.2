Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2DKF7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 01:59:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41205 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2DKF7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 01:59:52 -0400
Message-ID: <4F851DCB.7090304@gmail.com>
Date: Wed, 11 Apr 2012 13:59:39 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: A question about backport jump label
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	We want to backport jump label for 2.6.32 x86_64 kernel on
RHEL5/RHEL6. Such two systems use old versions of gcc 4.1 and 4.4,
so they have not "asm goto" support, which is required for jump label.

	I tried some ways to implement jump label without any
modification of core implementation, but all are failed.

	My tries are focus on x86's arch_static_branch() modification.
So far, I don't found out any good alternative solution of "asm
goto" in old gcc. The last try is failed since its my implementation
can't be invoked at same function multi times. The reason is GNU as does
not assign different addresses on same symbol.

	My question, is possible to implement to jump label under such
constraints? It's best to keep same interface with upstream tree.

	Any suggestions is welcome, thanks.

Yu

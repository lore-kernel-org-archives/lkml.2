Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2BAFxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 00:53:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39257 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2BAFxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 00:53:40 -0500
Message-ID: <1328075615.2617.47.camel@edumazet-laptop>
Subject: Re: [PATCH] Fix logical and operator at interrupt handler thread
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Geunsik Lim <geunsik.lim@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 01 Feb 2012 06:53:35 +0100
In-Reply-To: <1328074891.2617.45.camel@edumazet-laptop>
References: <1328073594-16673-1-git-send-email-geunsik.lim@gmail.com>
	 <1328074891.2617.45.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 février 2012 à 06:41 +0100, Eric Dumazet a écrit :

> I guess you could instead use jump_label here to shorten the code.

(since its not hot path anyway, its probably not worth it)



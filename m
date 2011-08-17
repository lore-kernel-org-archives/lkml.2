Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1HQTRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:17:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43761 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1HQTRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:17:03 -0400
MIME-Version: 1.0
In-Reply-To: <1313608515-14033-1-git-send-email-me@akshayjoshi.com>
References: <4E4B54A4.4040203@kernel.org>
	<1313608515-14033-1-git-send-email-me@akshayjoshi.com>
Date: Wed, 17 Aug 2011 15:17:01 -0400
Message-ID: <CAOJpy9u669cEs2xvMw2ok=Jc+pC0YtV7R3-sk=eEnhO3z0irzw@mail.gmail.com>
Subject: Re: [PATCH 4/9] Staging: Winbond: Convert C99 style comments in Winbond.
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Akshay Joshi <me@akshayjoshi.com>, Pekka Enberg <penberg@kernel.org>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updated patch should fix the comment concerns.

Pekka, I did compile-test it, but it slipped through since the comment
was followed by another comment and not a line of code.

Once again, sorry about that.

Akshay

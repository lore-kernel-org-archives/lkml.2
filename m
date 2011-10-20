Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1JTLGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 07:06:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34726 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1JTLGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 07:06:48 -0400
Subject: Re: [PATCH 12/21 v2] m68k: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E9FB0D6.9080301@snapgear.com>
References: <1318925407.6414.22.camel@x61.thuisdomein>
	 <4E9D6C05.9040106@snapgear.com> <1318941043.6414.35.camel@x61.thuisdomein>
	 <4E9FB0D6.9080301@snapgear.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 13:06:43 +0200
Message-ID: <1319108803.8405.28.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 15:25 +1000, Greg Ungerer wrote:
> Yes, that is the idea. The configurer doesn't need to know it has
> no effect (at least currently anyway). But they know that the board
> is supported.

I'm not too fond of control knobs connected to nothing (which this
Kconfig entry now is). Maybe I'll propose an alternative, one day.

> Yes, thats fine, I will fix it and apply.

Thanks.


Paul Bolle


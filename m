Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0KHRtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:49:10 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:47542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0KHRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:49:08 -0500
To: <sowani@gmail.com>
Subject: Re: [PATCH 2.6.36 1/1] mac80211: fix for tx.c compiler warnings.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 08 Nov 2010 18:49:06 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <4CD81EDD.1000309@gmail.com>
References: <4CD81EDD.1000309@gmail.com>
Message-ID: <7383627c9e4034d3837bec0475bf62e6@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-sips-origin: local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Nov 2010 21:31:33 +0530, Atul Sowani <sowani@gmail.com> wrote:
> Added conditional compilation with CONFIG_MAC80211_MESH to avoid compile
> time
> warning about declared but unused variable.

2.6.36? Really? a trivial warning fix for the stable tree? I don't think
so...


> +#ifdef CONFIG_MAC80211_MESH
>  	struct ieee80211s_hdr mesh_hdr;
> +#endif

Besides, it should be __maybe_unused.

johannes

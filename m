Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2AXAna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:43:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32954 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2AXAn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:43:29 -0500
Date: Mon, 23 Jan 2012 16:43:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Jones <drjones@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
        david.woodhouse@intel.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, arnd@arndb.de,
        holt@sgi.com, linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com,
        jesper nilsson <jesper.nilsson@axis.com>, dhowells@redhat.com,
        takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
In-Reply-To: <20120123134632.GA8235@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201231641380.19019@chino.kir.corp.google.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com> <20120118122830.037f1e29.akpm@linux-foundation.org> <20120123134632.GA8235@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, Andrew Jones wrote:

> I thought EXPERT was the best way to manage the visibility of expert
> options, but probably not, since it's prone to silent default changing.

Why not propose patches to subsystem maintainers to erradicate "default 
EXPERT" or "default !EXPERT"?

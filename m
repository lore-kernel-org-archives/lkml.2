Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab2CTMLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:11:40 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:50516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2CTMLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:11:39 -0400
Subject: Re: [PATCH 4/4] compat: add some tracing backport work
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        lf_driver_backport@lists.linux-foundation.org
In-Reply-To: <1332214021-9716-5-git-send-email-mcgrof@frijolero.org> (sfid-20120320_042820_342785_1C57CC56)
References: <1332214021-9716-1-git-send-email-mcgrof@frijolero.org>
	 <1332214021-9716-5-git-send-email-mcgrof@frijolero.org>
	 (sfid-20120320_042820_342785_1C57CC56)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Mar 2012 13:11:37 +0100
Message-ID: <1332245497.3329.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 20:27 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> Its not really easy to backport the tracing stuff, but
> lets give it a shot. We should simply review how many
> subsystems we want tracing for and for what target kernels
> we want that enabled for. It doesn't make sense to
> backport tracing if we won't have much users.

Frankly, I don't really want to think about backporting tracing since
it's so complex internally ...

It seems worthwhile though to have macros that disable tracing instead
of having to have a patch.

johannes


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab0ESL4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:56:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:52889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208Ab0ESL4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:56:36 -0400
Date: Wed, 19 May 2010 13:56:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Stephane Chatty <chatty@enac.fr>, wylda@volny.cz,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, Tejun Heo <tj@kernel.org>,
       linux-input@vger.kernel.org, Jerome Vidal <jerom3@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] HID: refactored special event handling in Roccat
 Kone
In-Reply-To: <1274200264.2243.4.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005191356200.28092@pobox.suse.cz>
References: <1274200264.2243.4.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Stefan Achatz wrote:

> >From e550163af2c39c4e7490cd5bf02e44c5dec72d2b Mon Sep 17 00:00:00 2001
> From: Stefan Achatz <erazor_de@users.sourceforge.net>
> Date: Sat, 8 May 2010 17:30:27 +0200
> Subject: [PATCH 4/5] HID: refactored special event handling in Roccat Kone
> 
> As special events are reported along with hid event information all
> events are now processed further by standard handler.
> Also cleaned up this code.

Applied, thanks for the cleanup.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

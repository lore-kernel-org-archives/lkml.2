Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1KCNhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:37:08 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:60530 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab1KCNhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:37:07 -0400
Subject: Re: [PATCH] kconfig: accept negative hexadecimals
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1320326160.14409.223.camel@x61.thuisdomein>
References: <1320326160.14409.223.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 14:36:50 +0100
Message-ID: <1320327410.14409.231.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 14:16 +0100, Paul Bolle wrote:
> But these will then show up as
> (eg) "0x-ff" in the GUI. Should that be fixed in a separate commit or
> should I update this patch?

Just a quick look into this showed that allowing negative hexadecimals
triggers quite a bit of trouble. So this needs a rethink. I guess this
all is only worthwhile if I can demonstrate a need for negative hex
digits (ie, if I submit something that requires the config tools to
actually allow those).

Anyhow, please forget this patch.


Paul Bolle


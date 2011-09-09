Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab1IIGpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:45:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34941 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1IIGpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:45:19 -0400
Subject: Re: [GIT PULL] UBIFS fixes for 3.1
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 09 Sep 2011 09:47:41 +0300
In-Reply-To: <20110906032236.19050.6306.sendpatchset@localhost.localdomain>
References: <20110906032236.19050.6306.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315550865.7905.15.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 06:22 +0300, Artem Bityutskiy wrote:
> Hi Linus,
> 
> please pull a fix an UBIFS regression - we mistakingly linked debuggin messages
> even when debugging was disabled.
> 
> The following changes since commit 93ee7a9340d64f20295aacc3fb6a22b759323280:
> 
>   Linux 3.1-rc2 (2011-08-14 15:09:08 -0700)

Just a reminder about this and similar UBI pull requests.

-- 
Best Regards,
Artem Bityutskiy


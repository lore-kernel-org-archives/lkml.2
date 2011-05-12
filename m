Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab1ELT11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:27:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46619 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542Ab1ELT10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:27:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: pm loss development
Date: Thu, 12 May 2011 21:27:44 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
In-Reply-To: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105122127.44484.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> What happen normally in runtime pm implementation is that every devices
> are switched off and are enabled only when needed.
> In our case instead we have a completely functional embedded system and,
> when an asyncrhonous event appear, we have only some tens milliseconds
> before the actual power failure takes place.
> This patchset add a support in order to switch off not vital part of the system,
> in order to allow the board to survive longer.
> This allow the possibility to save important data.

OK, so first, who decides what parts of the system are vital and what aren't?

Thanks,
Rafael

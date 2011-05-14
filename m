Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab1ENSvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 14:51:47 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37476 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1ENSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 14:51:46 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] pm loss development
Date: Sat, 14 May 2011 20:53:34 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Raffaele Recalcati <lamiaposta71@gmail.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <201105122127.44484.rjw@sisk.pl>
In-Reply-To: <201105122127.44484.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105142053.34920.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 12. Mai 2011, 21:27:44 schrieb Rafael J. Wysocki:
> On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > What happen normally in runtime pm implementation is that every devices
> > are switched off and are enabled only when needed.
> > In our case instead we have a completely functional embedded system and,
> > when an asyncrhonous event appear, we have only some tens milliseconds
> > before the actual power failure takes place.
> > This patchset add a support in order to switch off not vital part of the system,
> > in order to allow the board to survive longer.
> > This allow the possibility to save important data.
> 
> OK, so first, who decides what parts of the system are vital and what aren't?

If you know that power is failing in a few miliseconds, only stuff that can lead to data
corruption is vital. In that timeframe you can't even flush buffers.

	Regards
		Oliver

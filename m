Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0EQWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:16:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59799 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0EQWQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:16:55 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@fifo99.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
References: <1273810273-3039-1-git-send-email-arve@android.com>
	<201005142308.48386.rjw@sisk.pl>
	<AANLkTilX0uhqrJtUSOC4smdH1M8V-h14J7YtRG4PPxOQ@mail.gmail.com>
	<201005172342.52660.rjw@sisk.pl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 17 May 2010 15:16:52 -0700
In-Reply-To: <201005172342.52660.rjw@sisk.pl> (Rafael J. Wysocki's message of "Mon\, 17 May 2010 23\:42\:52 +0200")
Message-ID: <87sk5qw4vf.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday 17 May 2010, Arve Hjønnevåg wrote:

>> 
>> How about:
>> 
>> PM: Add opportunistic suspend support.
>
> "PM: Opportunistic suspend support" would be sufficient IMO.
>
> Now, I'd start with the motivation.  Like "Power management features present
> in the current mainline kernel are insufficient to get maximum possible energy
> savings on some platforms, such as Android, because ..." (here go explanations
> why this is the case in your opinion).

Yes, this will be helpful.

> Next, "To allow Android and similar platforms to save more energy than they
> currently can save using the mainline kernel, introduce a mechanism by which
> the system is automatically suspended (i.e. put into a system-wide sleep state)
> whenever it's not doing useful work, called opportunistic suspend".

Hopefully, a definition of "useful" will be given here, including by
what standards on-going work is determined not to be useful.

Kevin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0ENQVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:21:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755143Ab0ENQVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:21:35 -0400
Date: Fri, 14 May 2010 09:19:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] input: Default to only using PNP for i8042 probing
 on x86
In-Reply-To: <1273853403-2870-3-git-send-email-mjg@redhat.com>
Message-ID: <alpine.LFD.2.00.1005140918160.3711@i5.linux-foundation.org>
References: <1273853403-2870-1-git-send-email-mjg@redhat.com> <1273853403-2870-3-git-send-email-mjg@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, there's no way I'd merge this for 2.6.34 any more, but one comment:

On Fri, 14 May 2010, Matthew Garrett wrote:
>
> Experimenting with Windows has revealed that it will not probe the
> keyboard controller unless a valid PNPACPI device is present. Change our
> behaviour to match, and add a new i8042.forcedprobe parameter to allow
> people to override it.

If you do this, then please remove the nasty __ia64__ #ifdef while at it.

		Linus

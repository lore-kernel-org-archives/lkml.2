Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0EJGw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:52:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:38657 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab0EJGwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:52:25 -0400
Date: Mon, 10 May 2010 08:52:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for eGalax Touchcontroller
In-Reply-To: <20100510045022.GA31327@barra.bne.redhat.com>
Message-ID: <alpine.LNX.2.00.1005100851540.9849@pobox.suse.cz>
References: <20100202034040.GA16880@barra.bne.redhat.com> <20100510045022.GA31327@barra.bne.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010, Peter Hutterer wrote:

> > I've got one of these devices on my desk and it seems that it suffers from
> > the ABS_Z/ABS_RX issue that we've seen in other devices before. This patch
> > uses the same reasoning as 9db630b48a99adb4156e205b812fba8959644280.
> 
> See https://patchwork.kernel.org/patch/76210/ for the original thread.
> This patch never got merged, were you waiting on me or did it just drop
> under the table?
> 
> I'm getting positive reports from users that this indeed fixes the issues
> for their device.
> https://bugzilla.redhat.com/show_bug.cgi?id=473144

Sorry, I have lost the original thread. I have applied the patch now.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

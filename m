Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab1LEVoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:44:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab1LEVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:44:45 -0500
From: Thomas Renninger <trenn@suse.de>
To: Jim Cromie <jim.cromie@gmail.com>
Subject: Re: [PATCH 19/25] pnp: if CONFIG_DYNAMIC_DEBUG, use pnp.ddebug instead of pnp.debug
Date: Mon, 5 Dec 2011 22:44:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com> <201112051547.43298.trenn@suse.de> <CAJfuBxzqCboEOdP5EtY1XwOffn8AtGEzhtHFBvA5cpT4YSL=nw@mail.gmail.com>
In-Reply-To: <CAJfuBxzqCboEOdP5EtY1XwOffn8AtGEzhtHFBvA5cpT4YSL=nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112052244.42655.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 December 2011 20:15:48 Jim Cromie wrote:
> On Mon, Dec 5, 2011 at 7:47 AM, Thomas Renninger <trenn@suse.de> wrote:
> > On Monday, December 05, 2011 06:42:42 AM Jim Cromie wrote:
> >> 2011/12/1 Thomas Renninger <trenn@suse.de>:
...
> >
> > As said, not a big deal. Maybe nicer, not sure.
> 
> I agree with this size assessment :-)
Please ignore my nit-picking.

This patch, making pnp dynamic debug aware, is a nice feature.

  Thomas

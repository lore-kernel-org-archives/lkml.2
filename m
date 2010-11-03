Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0KCOq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:46:57 -0400
Received: from kroah.org ([198.145.64.141]:57018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab0KCOqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:46:55 -0400
Date: Wed, 3 Nov 2010 07:45:45 -0700
From: Greg KH <greg@kroah.com>
To: Konstantin Katuev <kkatuev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging: keucr driver: fix uninitialized variable & proper
	memset length
Message-ID: <20101103144545.GA3665@kroah.com>
References: <AANLkTi=oFai7Mh_VmzeV1TanF-dfmGs=KWOgj+03V2iH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=oFai7Mh_VmzeV1TanF-dfmGs=KWOgj+03V2iH@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 12:18:18PM +1100, Konstantin Katuev wrote:
> There was commented out transfer_flags initialization.
> And i think memset should fill entire structure, not only length of
> pointer to it.

This patch is line-wrapped and the tabs are converted to spaces so I
can't apply it at all.  Care to resend it again?

thanks,

greg k-h

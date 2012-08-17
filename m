Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030596Ab2HQDJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:09:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030486Ab2HQDJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:09:50 -0400
Date: Thu, 16 Aug 2012 20:09:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] dyndbg: trivial fixes
Message-ID: <20120817030946.GC7373@kroah.com>
References: <1345171043-14859-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345171043-14859-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 08:37:21PM -0600, Jim Cromie wrote:
> 2 trivial patches here, suitable for 3.6:
> - fix spelling error in comment s/control/control

That's not for 3.6, that's 3.7, at the earliest.

> - add write size attempted to log warning issued for E2BIG error

Same here.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3AGXBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:01:50 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39698 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3AGXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:01:48 -0500
Date: Mon, 7 Jan 2013 15:01:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Patrik Karlin <patrik.karlin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: fixed const coding style issue in
 binder.c
Message-ID: <20130107230144.GA29765@kroah.com>
References: <no>
 <1357582312-3024-1-git-send-email-patrik.karlin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357582312-3024-1-git-send-email-patrik.karlin@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 07:11:52PM +0100, Patrik Karlin wrote:
> This is a patch to add const to the lists of strings in binder.c
> as suggested by checkpatch.pl
> 
> Signed-off-by: Patrik Kårlin <patrik.karlin@gmail.com>
> ---
>  drivers/staging/android/binder.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Sorry, I just applied a patch from someone else that did this same
thing, that was sent to me a few weeks ago.

greg k-h

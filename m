Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030507Ab2CGWHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:07:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54685 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030251Ab2CGWHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:07:36 -0500
Date: Wed, 7 Mar 2012 14:07:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Dima Zavin <dima@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 02/13] android: ram_console: set CON_ANYTIME console flag
Message-ID: <20120307220732.GA16652@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
 <1331157503-3413-3-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331157503-3413-3-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:58:12PM -0800, John Stultz wrote:
> Change-Id: I1d2694d05ac9415669a92f38efdd8e71c927705b

What's this crud?  It doesn't belong in kernel.org commits :(

Care to remove them all from this series so you don't forget to do it
next time if I were to do it for you?

thanks,

greg k-h

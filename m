Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1BGKKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:10:20 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63940 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab1BGKKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:10:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=neNp+HXWTS6KXGzQySgniuvoCerXTBFknler/pNh/85Wb+LbtrKGxDHLMlbIkimQa8
         bEejsLsw3sY6vVhNDAnItUmOZU/2sYH5JwM7ocEM4+oEhHsr2WbCFkaMk9dDl7MbNnoH
         KwR/fzsPufy9LNmhQ9R9PWLfXqLi0FzRjxjJE=
MIME-Version: 1.0
In-Reply-To: <201102062107.49909.rjw@sisk.pl>
References: <201102061519.11360.rjw@sisk.pl>
	<201102062106.29712.rjw@sisk.pl>
	<201102062107.49909.rjw@sisk.pl>
Date: Mon, 7 Feb 2011 19:10:18 +0900
Message-ID: <AANLkTim7Q==ndSRDjAFF+tgRFqFory3Q9nJBPEQKuEEo@mail.gmail.com>
Subject: Re: [PATCH 1/2] USB / Hub: Do not call device_set_wakeup_capable()
 under spinlock
From: Minchan Kim <minchan.kim@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 5:07 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> A subsequent patch will modify device_set_wakeup_capable() in such
> a way that it will call functions which may sleep and therefore it
> shouldn't be called under spinlocks.  In preparation for that, modify
> usb_set_device_state() to avoid calling device_set_wakeup_capable()
> under device_state_lock.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Reported-by: Minchan Kim <minchan.kim@gmail.com>
Tested-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1KUWnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 17:43:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38878 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1KUWnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 17:43:00 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1111211012550.1848-100000@iolanthe.rowland.org>
References: <CAKYAXd-sZrF0DD=cuRVAX3Uoivi6fYhpM5P=awaUUU=oQ8ZVow@mail.gmail.com>
	<Pine.LNX.4.44L0.1111211012550.1848-100000@iolanthe.rowland.org>
Date: Tue, 22 Nov 2011 07:42:58 +0900
Message-ID: <CAKYAXd_4a9qDkuA6eTS5V0NfDnorRAUyh9T5=bSxzgqpmfcL=w@mail.gmail.com>
Subject: Re: [PATCH] NLS: raname "maxlen" to "maxout" in UTF conversion routines
From: NamJae Jeon <linkinjeon@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Clemens Ladisch <clemens@ladisch.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/22 Alan Stern <stern@rowland.harvard.edu>:
> As requested by NamJae Jeon, this patch (as1503) changes the name of
> the "maxlen" parameters to "maxout" in the various UTF conversion
> routines.  This should make the role of that parameter more clear.
>
> The patch also renames the "len" parameters to "inlen", for the same
> reason.
>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
>
> ---
>
> NamJae, I hope you like this better.  Since Greg has already accepted
> the first patch, I decided it was easier to write a new patch to change
> the variable names.
>
>

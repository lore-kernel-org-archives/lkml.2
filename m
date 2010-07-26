Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0GZXqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 19:46:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56635 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0GZXqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 19:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=khMgzr2epfUeaB9xyOIhP+i4yuHxQAf+gdWFEd2w9DZ2QL1Gfb0NJH/8q0qPVOFt9v
         zC8g1fzN1tioYl8UVRRzfGBsTFd1kn2gHnT0Q2uIGstoMnHQIag7ZSOsS6XDZER6OCet
         NxskxrPgYX1r8Xy6UNMms2gwh41XmCgs30/SQ=
MIME-Version: 1.0
In-Reply-To: <20100726224301.GA5287@kroah.com>
References: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
	<20100726224301.GA5287@kroah.com>
Date: Tue, 27 Jul 2010 09:46:00 +1000
Message-ID: <AANLkTikmDu+sOfNFwCJmshyKmeF5B1sZg6r+5_0qKc_8@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: comedidev: Removed unused macro 
	definitions
From: Michael Jensen <emjay1988@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 8:43 AM, Greg KH <greg@kroah.com> wrote:
>
> This doesn't apply against the linux-next tree as this macro is already
> gone from there.
>
> What tree are you creating this diff against?
>
> confused,
>
> greg k-h
>

The main tree, cloned from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

-- 
Regards,

Michael Jensen

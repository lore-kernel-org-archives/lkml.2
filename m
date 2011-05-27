Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab1E0JcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 05:32:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39293 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab1E0JcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 05:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=C5lQK1HDvpEumq18N2OAqonhPgqq4TNSAiLNIXtkbI5FfPo9ydYbr12QSA+ZZgSaKJ
         2H6403cC/8gaUUnUPa8vnuZd6mfPZLwY+iKmtmLwPiFLIcXPPi4nMutBNngAdFKZzwJ7
         cqIIa+VeCInD9U7RBstzfy6/rFqoNOZZnLzMo=
MIME-Version: 1.0
In-Reply-To: <1306487816-9778-1-git-send-email-mchang@novell.com>
References: <1306487816-9778-1-git-send-email-mchang@novell.com>
Date: Fri, 27 May 2011 17:32:12 +0800
X-Google-Sender-Auth: fZBK1X2UoXoQ3MH9gsYYQpEvsgM
Message-ID: <BANLkTinSB8pqexEHe-hmqVy9K=NW_2oNHg@mail.gmail.com>
Subject: Re: [PATCH] staging/gma500: get control from firmware framebuffer if conflicts
From: Michael Chang <mchang@novell.com>
To: gregkh@suse.de
Cc: alan@linux.intel.com, error27@gmail.com, justinmattock@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michael Chang <mchang@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry the first patch is problematic, it may not work if you try to
apply it, because it was sent from my gmail webmail. I have problem in
setting the git send-email that time and now it just get fixed. I
resend the patch again with git send-email.

Please use new patch. Thanks.

Regards,
Michael Chang

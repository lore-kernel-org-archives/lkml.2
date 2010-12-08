Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0LHURa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:17:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61600 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0LHUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:17:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=OiRAlug5iHiw1YcTnSCIlPDmx+75DldIhGGQs1F2iRAgPzLQZHfSZ2+QuRCz6gHW+A
         sa+234pJSD7Zd5IyCSfSIcnmd8zGYAZ3yjjANc7rTxAd9/8nFAjTn8kZ5lJfw+wIA29L
         jNh0PpEOUpvCuLvnc+KcZhOsBQyvwJ0/bXNac=
MIME-Version: 1.0
In-Reply-To: <4CFFE46C.60401@euromail.se>
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
 <4CFFC3C2.1080905@canonical.com> <4CFFCD10.5030202@euromail.se>
 <4CFFD0BF.2020601@canonical.com> <4CFFD3FE.1090103@euromail.se>
 <4CFFD801.8060704@canonical.com> <4CFFDB35.2020506@euromail.se>
 <AANLkTi=iw+7CDhbO4N9rMVSwS0t93BaaBVgoAwz-GeHo@mail.gmail.com> <4CFFE46C.60401@euromail.se>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Wed, 8 Dec 2010 21:17:07 +0100
Message-ID: <AANLkTim0bb=fvPYxKKghLz8sS0RE8Ud8QwjFrpinN5CQ@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Add an envelope tool type
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 9:02 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> This is precisely what the patch for ABS_MT_DISTANCE is for. Perhaps you meant
> to comment on that email. This one is about support for hardware without
> individual finger detection capabilities.

yes, I mixed up mails :)

i

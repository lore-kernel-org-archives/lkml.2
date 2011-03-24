Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab1CXHdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:33:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65071 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab1CXHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:33:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=F5Bq1X/lMpR5mSQ0HS66ZkhvDHxja+lyWUPFQlc2556wP4mXXQmDdXHwK0e2fgj2e0
         LH2HZ/enEr06j3l+PNTgCtACzfSwTb3WEAzVpKOSB9NSvV/JX1k6tcHAlgzimYOFXj5I
         jUUeKriPYwyK5lfKwFTVt27/GFRFZ0h2NKL5w=
MIME-Version: 1.0
In-Reply-To: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
Date: Thu, 24 Mar 2011 08:33:33 +0100
Message-ID: <AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
From: Corentin Chary <corentin.chary@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 8:39 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>
> This button is unusual. On press it emits scanocde 0xe4, on release
> 0xe5, and when held for a few seconds it begins emitting 0xea about
> twice per second. I chose to handle only the press event in order to
> make it behave like the other hotkeys.
>
> Probably the closest thing to the intended function of this button
> would be to alternate the display orientation between portrait and
> landscape, but since there doesn't appear to be a keycode defined for
> that function I went with KEY_PROG2. I'm open to other suggestions
> however.

Hi,
The manual says that under Windows, this is the "Home Key", so
KEY_HOME would be more appropriate.
Also, it would be great to preserve key up and key down informations
(sparse keymap have an "autorelease" parameter to control that).
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net

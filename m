Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab0IGKML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 06:12:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64377 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab0IGKMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 06:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lvJ9GWWzkE8Ri41GcLAze01J6+GgPNxjn7ofLoWA2MJhIdDWzzk+vEtJeLtKS7T4X7
         wAq8vk2OD4Mc/zaETLubvUhv+UUoaJdbckCyTXMIUIvfC0z5ReEyd7QzqCSk3//xZj+6
         SoMTK6GMyB/LjVBYgbBHWArgAtyKx9acOy+f4=
MIME-Version: 1.0
In-Reply-To: <4C860C21.40708@ru.mvista.com>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
	<5A47E75E594F054BAF48C5E4FC4B92AB03291AE03E@dbde02.ent.ti.com>
	<20100906201852.GB5162@suse.de>
	<4C860C21.40708@ru.mvista.com>
Date: Tue, 7 Sep 2010 14:12:07 +0400
Message-ID: <AANLkTins336XV97o=72YdqLf1Gr_hA9NjMNqcaWDosfK@mail.gmail.com>
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Greg KH <gregkh@suse.de>, "Gadiyar, Anand" <gadiyar@ti.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 7, 2010 at 1:55 PM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
>
>   It was caught by me on the list too, right at the same day the patch was
> posted. The author remained silent though...
>

Sorry for being silent - I had lots of things to do. Regarding the
patch itself - I respect kernel coding conventions, but I think it is
bad to have two different code styles in one file. Note, this is my
personal opinion only.

Kind regards,
Maxim

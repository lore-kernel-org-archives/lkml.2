Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1AZKDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:03:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60411 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1AZKDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:03:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BOU22U+JYd75CTjub94YQw+1Ll3CsPCQIjVZ9UAMPvau0cz4E0WwNSXd6GDwTHpW25
         tQ/ewusxDFP/jfbR4CxOMWWAucfXsowp20Zl/7is1hrqxNJVgushtsZ6fjY+rcl++SCo
         g319wauVi36/7mZJhDNkvNPodrbvArUBImxis=
MIME-Version: 1.0
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D6329793@irsmsx504.ger.corp.intel.com>
References: <1296036004-15644-1-git-send-email-lliubbo@gmail.com>
	<C5C86A19469DAE48AAAD0E5F3716E44501D6329793@irsmsx504.ger.corp.intel.com>
Date: Wed, 26 Jan 2011 18:03:32 +0800
Message-ID: <AANLkTinzHZorkTpDSv5J9_Q5kO5UUFnZb3CAafyOu2Qe@mail.gmail.com>
Subject: Re: [PATCH] firmware_classs: change val uevent's type to bool
From: Bob Liu <lliubbo@gmail.com>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "gregkh@suse.de" <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 5:56 PM, Berg, Johannes <johannes.berg@intel.com> wrote:
> @@ -463,7 +463,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>        f_dev->parent = device;
>        f_dev->class = &firmware_class;
>
> -       dev_set_uevent_suppress(f_dev, true);
> +       if (uevent)
> +               dev_set_uevent_suppress(f_dev, true);
>
> Everything but this is a no-op basically, but you didn't even describe this change?
>


Hmm.. Sorry for that, but I mentioned that by "fix a place missing
uevent check".
I added this check because I think it should be paired with following
dev_set_uevent_suppress(f_dev, false).

-- 
Regards,
--Bob

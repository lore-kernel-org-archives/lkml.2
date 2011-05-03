Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1ECA5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:57:09 -0400
Received: from mail-bw0-f52.google.com ([209.85.214.52]:62010 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab1ECA5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:57:08 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 20:57:07 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kiPEnSmVKmeTQYXh6aNb1/wuVT8Zp8SeW/NOaoS+7UgD0w1sgUmnJjIlktZr4O2O21
         qBSq2udlqOHHNDmE5/yjT1yzMB2rFz0fy2zwqklQCs/8D5RgvxZ24raTrenpGinDSzfL
         1Ysj5NUNkbVSpp3EfPs41qfe6SaRAaygA+fHw=
MIME-Version: 1.0
In-Reply-To: <1304382188-29530-1-git-send-email-riyer@nvidia.com>
References: <1304382188-29530-1-git-send-email-riyer@nvidia.com>
Date: Mon, 2 May 2011 17:48:54 -0700
Message-ID: <BANLkTimFKzQk0u3Kwq0MXRXEjUg8xb1JOA@mail.gmail.com>
Subject: Re: [v1] Input: tegra-kbc - modify keypress wakeup logic.
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer@nvidia.com
Cc: rydberg@euromail.se, amartin@nvidia.com, olof@lixom.net,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakesh,

On Mon, May 2, 2011 at 5:23 PM,  <riyer@nvidia.com> wrote:
> From: Rakesh Iyer <riyer@nvidia.com>
>
> Modify wakeup logic so either all keypresses wake the system or none do.

You need to provide justification for this change (i.e. why the new
way is better).

Thanks.

-- 
Dmitry

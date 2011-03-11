Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1CKRjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:39:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37485 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1CKRi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GJmqgZC6VAr2skzXfLCSqomrqcsucpasAgnSB/08orYzN6cBp/PvB6wnPSNB6cTja9
         6M768r9CSvMVR8QsGFyilGdhn8JOefZ+00mx0qI8lmobEZcUlkevX4jCbwlYN+juXj72
         2cFTigpg+OCHkc7MLuMNUYUfLXFsQG2HUFvYs=
MIME-Version: 1.0
In-Reply-To: <1299864633-27542-1-git-send-email-felipe.contreras@nokia.com>
References: <1299864633-27542-1-git-send-email-felipe.contreras@nokia.com>
Date: Fri, 11 Mar 2011 19:38:57 +0200
Message-ID: <AANLkTi=Hy18s5fOziHSNdG6QUZE85bg0Bb9cAqE42mVQ@mail.gmail.com>
Subject: Re: [RESEND PATCH] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>, Greg KH <greg@kroah.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tuomas Kulve <tuomas@kulve.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 7:30 PM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> We need to protect not only the dmm_map list, but the individual
> map_obj's, otherwise, we might be building the scatter-gather list with
> garbage. So, use the existing proc_lock for that.
>
> I observed race conditions which caused kernel panics while running
> stress tests, also, Tuomas Kulve found it happening quite often in
> Gumstix Over. This patch fixes those.
>
> Cc: Tuomas Kulve <tuomas@kulve.fi>
> Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>

Omar, 2.6.38 is imminent, if this patch has any chance of getting in,
I think you would need to push it soon.

Cheers.

-- 
Felipe Contreras

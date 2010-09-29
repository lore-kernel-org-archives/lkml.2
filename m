Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0I2GyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 02:54:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63122 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab0I2GyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 02:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=T7S1Fp5BX/dZPXOW0zjiJ6Q/VZXpufNMci5M9CHnUAOQMF7lHlZrBm2qDCQKW83aZ2
         oq3MP7mskZ04G3r7zBp1XLxBuJnZG+DoU3GRXQbU7u2VE4X0ek9PHid93+AMQt0THUcf
         d7diO+V6qdC6T4RDhKdUTAxWokjA/Xxc8SeIM=
MIME-Version: 1.0
In-Reply-To: <1285742774-5013-1-git-send-email-dima@android.com>
References: <1285742774-5013-1-git-send-email-dima@android.com>
Date: Wed, 29 Sep 2010 09:54:08 +0300
X-Google-Sender-Auth: SxJ9sCPxKdPwdUBHb1RI1-5ac6o
Message-ID: <AANLkTimM9bHqGtuNisYjOtL=d014CzB3foQSnnf-bPkv@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: normalize sleeper's vruntime during group change
From: Pekka Enberg <penberg@kernel.org>
To: Dima Zavin <dima@android.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 9:46 AM, Dima Zavin <dima@android.com> wrote:
> This adds a new callback, prep_move_task, to struct sched_class
> to give sched_fair the opportunity to adjust the task's vruntime
> just before setting its new group.
>
> This allows us to properly normalize a sleeping task's vruntime
> when moving it between different cgroups.
>
> Cc: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: Dima Zavin <dima@android.com>

Nitpick: this changelog probably needs better description of the
problem it's trying to solve or a link to the previous discussion
about it.

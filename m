Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0H3Jyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:54:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58385 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab0H3Jym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=TUN56htdn5RkZX0dx9zj295r5SJKvRWAhhM3n+i+AQ1bBlX5HI/hrrkGU86O/s1kep
         hFjIbP7gAEAijtyt5BFYNBxonnLg6+PEJlmgje/WCG6cmK2bB6bdd0vpDy82LiovwpbG
         Jxb+cYLYJ1kv06uevPRiLj0l6IC0sCvZpV0H4=
MIME-Version: 1.0
Reply-To: trapdoor6@gmail.com
In-Reply-To: <4AUWBNzTkbD.A.mj.QGueMB@chimera>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.mj.QGueMB@chimera>
Date: Mon, 30 Aug 2010 10:54:41 +0100
Message-ID: <AANLkTikpoH-_od-SL3=Q7a=xbsraE4rYGicx7mmS92Cw@mail.gmail.com>
Subject: Re: [Bug #16881] [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing
 textures in 0 A.D.
From: trapDoor <trapdoor6@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 11:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16881
> Subject         : [REGRESSION, Radeon-KMS] 2.6.36-rc1,2 - missing textures in 0 A.D.
> Submitter       :  <trapdoor6@gmail.com>
> Date            : 2010-08-24 12:20 (6 days old)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

There was at least one drm pull between 2.6.36-rc2 and -rc3. So I
tested on -rc3 and I confirm that the issue is still present.

I was going to update the bugzilla entry but it won't let me log in at
this moment.

-- 
Regards
Tomasz

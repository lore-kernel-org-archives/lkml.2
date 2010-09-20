Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0ITVHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:07:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56907 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab0ITVHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZqRf7gApdqObX8bf9094GZn0/oAns6HmUTxV6kubE3Gb7x8nOWpa3N/8lsli1KEHlY
         helHyBBX/Bd4Rq2tTpZY+NDqNhGGdyqFOGcHJa+CRra7Ys37Ob+VcoaESeYAZTa4/87h
         t+Ju/QvIK12k3tk2z5c6Gs6rWnbnfo4QxwtDk=
MIME-Version: 1.0
In-Reply-To: <aRnAGz9xZ8K.A.SAG.e_7lMB@chimera>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
	<aRnAGz9xZ8K.A.SAG.e_7lMB@chimera>
Date: Mon, 20 Sep 2010 22:07:46 +0100
Message-ID: <AANLkTik5gibBKuayOvCsp0ZGxQWC0saGGbGgnQ=HOCSx@mail.gmail.com>
Subject: Re: [Bug #16462] unable to connect to AP on legal channel 13
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On 20 September 2010 20:57, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16462
> Subject         : unable to connect to AP on legal channel 13
> Submitter       : Daniel J Blueman <daniel.blueman@gmail.com>
> Date            : 2010-07-25 17:06 (58 days old)

I have verified this issue still exists in 2.6.36-rc4, alas.

Thanks,
  Daniel
-- 
Daniel J Blueman

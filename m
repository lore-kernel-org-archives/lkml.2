Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab0GXFRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 01:17:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59754 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0GXFRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 01:17:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FmrHUHz/+nS/cRAUVCuwdfBnVjGWlaD7s5DyX5fQydsPjG+u7SePqRuMnnzLOcey7b
         isRw271kvfBxGT7cMfmii9/FwgYpWIsHM3IMTrI0AHP0jaTNamHbD+vBzEemLEXSoyp/
         bODXiUag9bOETAsUVHXClsZurpw+T5eb67Zs8=
MIME-Version: 1.0
In-Reply-To: <tneGvaw1wLL.A.mr.82XSMB@chimera>
References: <Lupw7pePXBO.A.fZH.G2XSMB@chimera> <tneGvaw1wLL.A.mr.82XSMB@chimera>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sat, 24 Jul 2010 08:17:16 +0300
Message-ID: <AANLkTinRWnb5wR5SQmf0DMTbAMTy=5X2LM3k3qPFJbPu@mail.gmail.com>
Subject: Re: [Bug #16353] 2.6.35 regression
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 14:47, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16353
> Subject         : 2.6.35 regression
> Submitter       : Zeev Tarantov <zeev.tarantov@gmail.com>
> Date            : 2010-07-05 13:04 (19 days old)
> Message-ID      : <loom.20100705T144459-919@post.gmane.org>
> References      : http://marc.info/?l=linux-kernel&m=127836002702522&w=2
> Handled-By      : Steven Rostedt <rostedt@goodmis.org>
> Patch           : https://patchwork.kernel.org/patch/110988/
>

Fixed in rc6.

-Zeev

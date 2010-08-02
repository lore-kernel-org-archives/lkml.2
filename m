Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0HBO7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:59:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34777 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0HBO67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VtcUqUF9xltzbMMtqhYIU/45K2IQQQkNCRsQl1ZwHAB00exEXOEw4oNZGq++YVUHuP
         6CklBGfX5u6SDl2feAYCWTzdDfxTcsx4CPWNbcNVR+mTjeLdqL+kLCQNMotJi1rFto+Y
         XfczntmasR5KtJQEVjTR4Q0zx1mL9hiUC/85c=
MIME-Version: 1.0
In-Reply-To: <Aan7wZ97YaE.A.H2D.0pXVMB@chimera>
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
	<Aan7wZ97YaE.A.H2D.0pXVMB@chimera>
Date: Mon, 2 Aug 2010 15:58:57 +0100
Message-ID: <AANLkTikmgrKTLtgs1+h+BkS5X6qt9bP1wMDL4Gu7L3u3@mail.gmail.com>
Subject: Re: [Bug #16462] unable to connect to AP on legal channels 12/13
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 August 2010 14:52, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16462
> Subject         : unable to connect to AP on legal channels 12/13
> Submitter       : Daniel J Blueman <daniel.blueman@gmail.com>
> Date            : 2010-07-25 17:06 (8 days old)

Yes, I just managed to reproduce this with 2.6.35-final, and will
update the bugzilla entry with the wire-capture needed.
-- 
Daniel J Blueman

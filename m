Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0H3Egu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 00:36:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59340 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab0H3Egs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 00:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=myVZ22FjRZoeBlNQynhDfehNVbI5zoaPVOkcWJolDOssQeqOJoPFSQVy6GLFkOK7dM
         5Vh3wnNldaSz1iEAkeZGKb0eKrl7+LUfmpCmzDDosrIj+f1rc+V/zSuXTGQxYJWG9nYX
         f7ZIFIt27+U78wC7VUhgM2obQGTydvo4QsFbk=
MIME-Version: 1.0
In-Reply-To: <4AUWBNzTkbD.A.FI.7FueMB@chimera>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.FI.7FueMB@chimera>
Date: Mon, 30 Aug 2010 06:36:47 +0200
Message-ID: <AANLkTikzDgHsPsUQMdb87R8dG61CBBekxBfhbuguLEPX@mail.gmail.com>
Subject: Re: [Bug #17041] 2.6.36-rc1 hangs during XFS barrier test for /
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17041
> Subject         : 2.6.36-rc1 hangs during XFS barrier test for /
> Submitter       : Torsten Kaiser <just.for.lkml@googlemail.com>
> Date            : 2010-08-20 (10 days old)
> Message-ID      : <AANLkTim1PXibiY98GUdMj-UZLTav+n7GAnJ0Mjn6_5a3@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=128231691708710&w=2

As noted in comment #1 in this Bug, this was the same Bug as
http://marc.info/?l=linux-kernel&m=128208298507451&w=2
It is fixed as of 2.6.36-rc2.

You can close this Bug as fixed.

Thanks, Torsten

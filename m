Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1ABVS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 16:18:57 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57955 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1ABVS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 16:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cClOwn80Hov6r6/jCgI5wIKD1KENdj6wq0VT2AlNfeNEitvZ/aqKKU9P8dMX3dF1Dh
         i1WyA8SribcryewE/6SVleVdwP+tAT3duJYuh0DqqcWXmUmjKlcKldH6AKIVdNxMUtc9
         0N7diVPHn0nl7SpYIgpJRgrv6csuEOccfj8Bw=
MIME-Version: 1.0
In-Reply-To: <LbeBv-BNQpL.A.KT.IG8GNB@chimera>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
	<LbeBv-BNQpL.A.KT.IG8GNB@chimera>
Date: Sun, 2 Jan 2011 21:18:55 +0000
Message-ID: <AANLkTi=2PZ81T4_vV4RiXgxZB3PHzpEfEisEN-cO1jjg@mail.gmail.com>
Subject: Re: [Bug #20332] [LogFS] [2.6.36-rc7] Kernel BUG at lib/btree.c:465!
From: Prasad Joshi <prasadjoshi124@gmail.com>
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

Hello,

I did not observe this bug with the latest kernel (2.6.37-rc8+).

Thanks and Regards,
Prasad

On Wed, Dec 29, 2010 at 11:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=20332
> Subject         : [LogFS] [2.6.36-rc7] Kernel BUG at lib/btree.c:465!
> Submitter       : Prasad Joshi <prasadjoshi124@gmail.com>
> Date            : 2010-10-12 18:56 (79 days old)
> Message-ID      : <AANLkTimAbCZNhLQ5nADUiAC+7JpAeJBEmjFwdxyZ-FxO@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=128690910501830&w=2
>
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0DILxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:53:11 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:35989 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0DILxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IeMBpbTkh4S3/B2vKTQanw803RotpFDpHftc3EFXklEltNL0e9/yolnw4BhomOBlZG
         pcHcbIKcQEQJ0r3oh/wKOz8raa1zqbdPglwfgcX6k6OLsWNIRx7rt0aTIpPJpRd7OuxK
         qJxpn2/8QWt10XRcP4WhQDre3Zlwfjck1Lno4=
MIME-Version: 1.0
In-Reply-To: <onZ81XwyNTD.A.eyB.8DmvLB@chimera>
References: <cjwJ7Pf9h0L.A.9pB.1DmvLB@chimera>
	 <onZ81XwyNTD.A.eyB.8DmvLB@chimera>
Date: Fri, 9 Apr 2010 13:53:04 +0200
Message-ID: <x2tca2dc2821004090453md93af391wfef3fc3393bc3a43@mail.gmail.com>
Subject: Re: [Bug #15733] Crash when accessing nonexistent GTT entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhenyu Wang <zhenyuw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 1:04 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.32 and 2.6.33.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.32 and 2.6.33.  Please verify if it still should
> be listed and let the tracking team know (either way).

It still should be listed.

>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15733
> Subject         : Crash when accessing nonexistent GTT entries in i915
> Submitter       : Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Date            : 2010-03-10 22:09 (30 days old)
> Message-ID      : <1268258994.2183.14.camel@carter>
> References      : http://marc.info/?l=linux-kernel&m=126825901326111&w=4
> Handled-By      : Zhenyu Wang <zhenyuw@linux.intel.com>
>                  Andrew Morton <akpm@linux-foundation.org>
>
>
>

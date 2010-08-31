Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab0HaCT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:19:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64064 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab0HaCT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=e71dKug6o68ixzQAOeh3cBrk70jnYebIyq5zRHQhPIDGnerx0geQq2HnJ3KfHCUQLf
         VwQAFtInyVI+072V5HK/pDT9nOi2ua2SPf7j7+M+Q+oX5/YTZ9c2JWJstLXDJ+6B9xme
         0a1dE2ujM0XkVGae2st2FyUDQ21KSNjNbwB8k=
MIME-Version: 1.0
In-Reply-To: <ByD_7B96czP.A.kdD.pgueMB@chimera>
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <ByD_7B96czP.A.kdD.pgueMB@chimera>
From: Kan-Ru Chen <ckanru@gmail.com>
Date: Tue, 31 Aug 2010 10:19:07 +0800
Message-ID: <AANLkTi=bLAr=9E6-nfn8r_qGNfxYCXADoA0M9PzWHLmy@mail.gmail.com>
Subject: Re: [Bug #16307] i915 in kernel 2.6.35-rc3, high number of wakeups
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Enrico Bandiello <enban@postal.uv.es>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 7:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16307
> Subject         : i915 in kernel 2.6.35-rc3, high number of wakeups
> Submitter       : Enrico Bandiello <enban@postal.uv.es>
> Date            : 2010-06-26 16:57 (65 days old)
> Message-ID      : <<4C26317A.5070309@postal.uv.es>>
> References      : http://marc.info/?l=linux-kernel&m=127757403404259&w=2

Same with v2.6.36-rc3

$ sudo powertop -d -t 20
...
Wakeups-from-idle per second : 196.2    interval: 20.0s
no ACPI power usage estimate available
Top causes for wakeups:
  25.4% ( 59.6)   [i915@pci:0000:00:02.0] <interrupt>
...

- Kanru

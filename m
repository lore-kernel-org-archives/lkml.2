Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab1C1LFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 07:05:20 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41863 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1C1LFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TFwI58hRDLzAxJUpLwjNxfb7tNTvtKIVjuATrN/IrvpCT+ArVO7iBaU95JnV6k8KgU
         twxp6/HaATvelTreJZ1/P0nXjaeTIA2FbN368aEjNs4MC2wdaES3G1CB6Vj7Lee3UzRp
         n1tuBEFlaICby2TT9rabJf5eIMrfP+cAOwCYQ=
MIME-Version: 1.0
In-Reply-To: <201103270058.41632.rjw@sisk.pl>
References: <201103270058.41632.rjw@sisk.pl>
Date: Mon, 28 Mar 2011 20:05:16 +0900
Message-ID: <AANLkTi=JW-xdzE3tCMohVZ1A=2pk2WHD0WrDPU4FNaXA@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime
 PM callbacks
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 8:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Remove the __weak definitions of platform bus type runtime PM
> callbacks, make platform_dev_pm_ops point to the generic routines
> as appropriate and allow architectures using platform_dev_pm_ops to
> replace the runtime PM callbacks in that structure with their own
> set.
>
> Convert architectures providing its own definitions of the platform
> runtime PM callbacks to use the new mechanism.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looking good, thanks Rafael. Tested on the sh7372 Mackerel board.

Acked-by: Magnus Damm <damm@opensource.se>

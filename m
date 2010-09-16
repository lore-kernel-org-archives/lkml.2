Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0IPXFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:05:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52177 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0IPXFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tthxW2zuJaqci4T54fp3Gr7feQvOuz6z/umBYhHGlgLhPNJfhYDJpt0pxo8i4UM47m
         j4ZmUlGHWiFMiQBft1sqWgI44JXtFM/4FRHvItd4dtbQyI8GvcunNXpdK8tVg8kG7LFV
         JEcL+4KZCdaLUlteeESYvG7s7ZCPsbd+s9EJg=
MIME-Version: 1.0
Date: Thu, 16 Sep 2010 19:05:28 -0400
Message-ID: <AANLkTikWmwVvWzRMK7yvtyqYbd4OeeR1nLsP1OAxbnJg@mail.gmail.com>
Subject: RE: [PATCH] VMware Balloon: rename module
From: Chetan Loke <chetanloke@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: pv-drivers@vmware.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Dmitry Torokhov
> Sent: September 16, 2010 6:01 PM
> To: linux-kernel@vger.kernel.org
> Cc: pv-drivers@vmware.com; Andrew Morton
> Subject: [PATCH] VMware Balloon: rename module
>


> In an effort to minimize customer confusion we want to unify naming
> convention for VMware-provided kernel modules. This change renames
> the balloon driver from vmware_ballon to vmw_balloon.
>
What will vmtools name its vmware_balloon driver to? vmw_balloon, correct?


> +	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
minor change - vmware_vmmemctl?

I might've seen a debugfs entry too.


side note - is it possible to extend the balloon driver to get a
notification on other events? like CPUs, NICs? Just an event is what
I'm looking for. No action need to be taken in the guest.

regards
Chetan Loke

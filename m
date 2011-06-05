Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1FEKPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 06:15:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49798 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1FEKPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 06:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FKrgKgJTcOS9Ufnzv+hjqBBFr4PFOZOLL3JesCVCwMOoMx8NwPOiAkHUZ3fMjrSGRf
         aR7suGRNrv3JirUV0IlZy4taVxkuYbX7g3NTl29IeYBEc9Ru7Pw1vrUlwygKZ3nBzbPJ
         ngtf06QVdFqEz0ddU71KsEmZSXAgsloNznvSM=
MIME-Version: 1.0
In-Reply-To: <F28B59AD52D84B479DCA469824475335065FEA9EBD@hasmsx503.ger.corp.intel.com>
References: <1305456228-15265-1-git-send-email-oren.jer.weil@intel.com>
	<BANLkTin4tWcJ-6Yjh_Yg18dNXNpiXjRA3A@mail.gmail.com>
	<F28B59AD52D84B479DCA469824475335065FEA9EBD@hasmsx503.ger.corp.intel.com>
Date: Sun, 5 Jun 2011 20:15:16 +1000
Message-ID: <BANLkTimcMemqxU+kYqSp=jiE16jn6y5XLg@mail.gmail.com>
Subject: Re: [PATCH 00/10] staging/mei: Intel MEI Driver
From: Dave Airlie <airlied@gmail.com>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>,
        "Winkler, Tomas" <tomas.winkler@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 6:15 PM, Weil, Oren jer <oren.jer.weil@intel.com> wrote:
>>From: Dave Airlie [mailto:airlied@gmail.com]
>>this device takes over the PCI driver for the host bridge, which stops the
> AGP
>>driver from loading which stops i915 from loading, which makes things sad.
>>Hopefully that is another
>>TODO on the list if it isn't already on it.
>>
>>I enabled it by mistake and then wondered what was going on.
>>
>>I think EDAC used to suffer from this issue as well.
>
> You can describe your system and send the dump of the PCI space (lspci --vv)
> and demsg?
>

Oh I may have blamed this code too quick, sorry was false alarm, my
.config didn't
match the box I was booting it on, and MEI was the last thing I
enabled in oldconfig.

Oops sorry again.

Dave.

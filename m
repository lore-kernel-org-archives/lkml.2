Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1BEPb0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 10:31:26 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46451 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1BEPbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 10:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=av4UcRu+PFBUKm4RNqtn46R5x2SvbXhkMms8m+ANfxx7QdYwe7vrS7PMvFkEmuZEV5
         67XpbyIAMzPJ93ohqB073HUVr3NhRmggCybmhBQ0Vh33ita5diEVyTNty+qhTB+LDqkp
         36Wj/WmlcCDNh+T6uW/PHbDiSg5SkhHho5ykU=
MIME-Version: 1.0
In-Reply-To: <201101250032.07423.rjw@sisk.pl>
References: <201101201226.41021.rjw@sisk.pl>
	<201101250025.10817.rjw@sisk.pl>
	<201101250032.07423.rjw@sisk.pl>
Date: Sat, 5 Feb 2011 23:31:23 +0800
Message-ID: <AANLkTi=nAhadVy6y6f4uOy0-pvTQrdwYgQ0y_4ukui2z@mail.gmail.com>
Subject: Re: [PATCH 8/8] ACPI / PM: Use existing ACPI iomaps for NVS
 save/restore (v2)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The suspend monster is back! The suspend-to-ram is fine, but upon
resume, screen is blank. Haven't bisected in case someone has also
done so.

It's very recent. ... between commit
831d52bc153971b70e64eccfbed2b232394f22f8 and
44f2c5c841da1b1e0864d768197ab1497b5c2cc1.

Thanks,
Jeff

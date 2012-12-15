Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2LOIZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 03:25:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34089 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2LOIZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 03:25:44 -0500
MIME-Version: 1.0
In-Reply-To: <50CBA03D.8050409@redhat.com>
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
	<1355415792.2229.7.camel@ul30vt.home>
	<CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
	<50CBA03D.8050409@redhat.com>
Date: Sat, 15 Dec 2012 16:25:42 +0800
Message-ID: <CANmqhJDdf=RhqQBqmVMJW5zn8H8Eb-FtQhOxSeeu+sezK2g8iQ@mail.gmail.com>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
From: Jason Gao <pkill.2012@gmail.com>
To: Don Dutile <ddutile@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 5:55 AM, Don Dutile <ddutile@redhat.com> wrote:
> forgot: did you check that all the bios settings are the same btwn
>         the 710 systems?

Bios settings should be the same between servers, I'v ignored these
errors and run KVM on this server,deployed  non-critical java
production applications running on kvm guest,

thanks

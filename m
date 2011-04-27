Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1D0DCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:02:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61148 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab1D0DCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VG8swMUFq7RoitJbGiAgINvOM6X2+0L45z96/TUt0vsD/ZGW77PSLVFImdn92po+dH
         4oHcRoYSDuWyop0U3hYdvq2TYgd76QFKL1Xo7QnN8/DUDMDy4/aM0/lKtUInCAm+2KDM
         r5hvWW5NnrtP3iyjI3rUd4D75LI4xIXZgVlLM=
MIME-Version: 1.0
In-Reply-To: <20110426130036.997a05fc.rdunlap@xenotime.net>
References: <20110426130036.997a05fc.rdunlap@xenotime.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 26 Apr 2011 23:02:13 -0400
Message-ID: <BANLkTi=+V=N-hOffAkNw6n59ipsRjcTFSg@mail.gmail.com>
Subject: Re: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT
 menu kconfig symbols
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Peter Foley <pefoley2@verizon.net>,
        torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 16:00, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Surround the EXPERT menu with "if EXPERT" and "endif" so that it
> is forced to stay as one unit.  Hopefully this will help to prevent
> it being broken in the future.

makes sense to me
-mike

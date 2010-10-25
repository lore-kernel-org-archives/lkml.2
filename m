Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab0JYUhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:37:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab0JYUha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:37:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in get_property()
Date: Mon, 25 Oct 2010 22:36:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101016141321.GA11054@sucs.org> <201010172032.43206.rjw@sisk.pl> <20101025131728.GC2162@ucw.cz>
In-Reply-To: <20101025131728.GC2162@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010252236.31530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 25, 2010, Pavel Machek wrote:
> Hi!
> 
> > That's why I suggested to use -ENODATA. :-)
> > 
> > Still, if user space has problems with failing reads from the sysfs attributes,
> > it may be better to simply put -1 in there.  Patch is appended, please test.
> 
> I'd say that reporting -1 for unknown is ugly. You can have -1A
> current easily (charging at 1A), and I've seen machines reporting <0
> current -- when charging. Logical and well-defined.

I posted a patch fixing that in a different way (makng the battery driver return
-ENODEV instead of -ENODATA) in the meantime, which has been confirmed to work.

Thanks,
Rafael

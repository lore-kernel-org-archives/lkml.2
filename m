Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2GSJF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:05:28 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47723 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2GSJFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:05:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 0/21] ACPI / PM: Switch ACPI bus type and drivers to dev_pm_ops
Date: Thu, 19 Jul 2012 11:11:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
References: <201206232306.06602.rjw@sisk.pl> <50079577.208@kernel.org>
In-Reply-To: <50079577.208@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191111.05824.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 19, 2012, Len Brown wrote:
> 
> > The patchset has been tested on Toshiba Portege R500 and more testing is in
> > the works.  If there are no objections, I'd like to push if for 3.6 through
> > the linux-pm tree.
> 
> Good plan.  Would need to merge w/ my tree only if we run into conflicts.
> 
> Acked-by: Len Brown <len.brown@intel.com>

Thanks a lot!

Rafael

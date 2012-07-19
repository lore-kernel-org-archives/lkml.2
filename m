Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab2GSFFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 01:05:03 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53414 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2GSFE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 01:04:59 -0400
Message-ID: <50079577.208@kernel.org>
Date: Thu, 19 Jul 2012 01:04:55 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org,
        Eric Piel <eric.piel@tremplin-utc.net>,
        Mattia Dongili <malattia@linux.it>,
        Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH 0/21] ACPI / PM: Switch ACPI bus type and drivers to dev_pm_ops
References: <201206232306.06602.rjw@sisk.pl>
In-Reply-To: <201206232306.06602.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The patchset has been tested on Toshiba Portege R500 and more testing is in
> the works.  If there are no objections, I'd like to push if for 3.6 through
> the linux-pm tree.

Good plan.  Would need to merge w/ my tree only if we run into conflicts.

Acked-by: Len Brown <len.brown@intel.com>

thanks,
Len Brown, Intel Open Source Technology Center

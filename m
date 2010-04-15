Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0DOGoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:44:19 -0400
Received: from poutre.nerim.net ([62.4.16.124]:54122 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0DOGoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:44:18 -0400
Date: Thu, 15 Apr 2010 08:44:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: Add driver for intel PCI thermal subsystem
Message-ID: <20100415084415.1e2a2e67@hyperion.delvare>
In-Reply-To: <20100414212748.ad4c3187.akpm@linux-foundation.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>
	<20100403170917.GA11397@srcf.ucam.org>
	<20100411102414.15b9b394@hyperion.delvare>
	<20100414212748.ad4c3187.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 14 Apr 2010 21:27:48 -0400, Andrew Morton wrote:
> On Sun, 11 Apr 2010 10:24:14 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> > On Sat, 3 Apr 2010 18:09:17 +0100, Matthew Garrett wrote:
> > > Jean, did you pick this up at any point? I can't see it in your git 
> > > tree.
> > 
> > Maybe because I don't have a git tree ;) I'm using quilt for my hwmon
> > patches.
> > 
> > Anyway, no, I did not pick this driver, I don't think I saw a public
> > review of it, and normally I only pick patches which have been reviewed
> > by someone I trust. Remember I am not the maintainet of the hwmon
> > subsystem any longer. I'm trying to help as my time permits, but I make
> > no guarantee.
> 
> I handle hwmon patches which Jean doesn't take or nack.

I've reviewed the driver meanwhile, now waiting for Matthew to submit
an updated patch.

-- 
Jean Delvare

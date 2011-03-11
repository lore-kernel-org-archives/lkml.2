Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1CKWSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:18:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52505 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1CKWSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:18:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/4] X86: Revamp reboot behaviour to match Windows more closely
Date: Fri, 11 Mar 2011 23:18:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1299877940-6870-1-git-send-email-mjg@redhat.com> <201103112308.18221.rjw@sisk.pl> <20110311221517.GA24173@srcf.ucam.org>
In-Reply-To: <20110311221517.GA24173@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103112318.19678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 11, 2011, Matthew Garrett wrote:
> On Fri, Mar 11, 2011 at 11:08:18PM +0100, Rafael J. Wysocki wrote:
> > On Friday, March 11, 2011, Matthew Garrett wrote:
> > > Windows reboots by hitting the ACPI reboot vector (if available), trying
> > > the keyboard controller, hitting the ACPI reboot vector again and then
> > > giving the keyboard controller one last go. Rework our reboot process a
> > > little to default to matching this behaviour, although we'll fall through
> > > to attempting a triple fault if nothing else works.
> > 
> > Does this fix a particular problem observed in practice?
> 
> Yup. We're seeing an increasing number of machines that don't implement 
> the legacy keyboard controller at all and fail to reboot if you poke it. 
> The expectation appears to be that you use the ACPI reboot vector on 
> these machines.

So perhaps you can put a pointer or two into the changelog?  That would
show precisely that it's not just for pure Windows compatibility.

Thanks,
Rafael

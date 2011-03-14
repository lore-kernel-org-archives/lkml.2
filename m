Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab1CNPus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:50:48 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:34176 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756452Ab1CNPuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:50:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Nm/phTDw8k3v+d8G6jtrrJ0UFn6BZnXsmjhCIxDnc0SLAZ+TaeoJ8ni1OYMnnuIhihLTxPg0a/itMVk3OEAAEXEWOvU36rX34flPbpF0ZXjMhJb1IzDbwhFjQz/BoAlX;
Date: Mon, 14 Mar 2011 08:50:34 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Denis Turischev <denis@compulab.co.il>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/3] pci_ids: add Intel Tunnel Creek LPC Bridge device
 ID.
Message-ID: <20110314085034.19d3430d@jbarnes-desktop>
In-Reply-To: <20110314114335.GN31153@sortiz-mobl>
References: <4D7CE230.1070004@compulab.co.il>
	<20110314114335.GN31153@sortiz-mobl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 12:43:36 +0100
Samuel Ortiz <sameo@linux.intel.com> wrote:

> Hi Denis,
> 
> On Sun, Mar 13, 2011 at 05:26:40PM +0200, Denis Turischev wrote:
> > Signed-off-by: Denis Turischev <denis@compulab.co.il>
> Jesse, are you ok with me carrying this patch ? The 2 following patches from
> this patchset depend on it, obviously.

Yeah, np, assuming the PCI IDs are used in several places.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center

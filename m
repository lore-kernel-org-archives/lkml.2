Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0E1TZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:25:52 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:59813 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755943Ab0E1TZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:25:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=IBhOssPc5+nUbfMg/n/ub4NxKzrlMAGU8/v1/sBdrrYjPL098XJksu0kkDMtHNdVrRCCRAFoPGtePldvPdcosfZGjzxG59M8hydwXvXdHTUbCngOph0iTD0Aa5QrPEa5;
Date: Fri, 28 May 2010 12:25:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI quirk: AMD 780: work around wrong vendor ID on APC
 bridge
Message-ID: <20100528122521.71ecab11@virtuousgeek.org>
In-Reply-To: <4BFCF616.6060608@ladisch.de>
References: <4BFCF616.6060608@ladisch.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 12:21:10 +0200
Clemens Ladisch <clemens@ladisch.de> wrote:

> In all AMD 780 family northbridges, the vendor ID of the internal
> graphics PCI/PCI bridge reads not as AMD but as that of the mainboard
> vendor, because the hardware actually returns the value of the subsystem
> vendor ID (erratum 18).
> 
> We currently have additional quirk entries for Asus and Acer, but it is
> likely that we will encounter more systems with other vendor IDs.
> 
> Since we do not know in advance all possible vendor IDs, a better way to
> find the device is to declare the quirk on the host bridge, whose ID is
> always correct, and use that device as a stepping stone to find the PCI/
> PCI bridge, if present.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center

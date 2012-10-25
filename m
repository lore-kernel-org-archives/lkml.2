Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946053Ab2JYOJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:09:30 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:31350 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945971Ab2JYOJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:09:28 -0400
Message-ID: <1351173714.19172.27.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] ACPI: Remove unused lockable in acpi_device_flags
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org, liuj97@gmail.com
Date: Thu, 25 Oct 2012 08:01:54 -0600
In-Reply-To: <4977274.iWiO0dh4FZ@vostro.rjw.lan>
References: <1350318870-5700-1-git-send-email-toshi.kani@hp.com>
	 <507E0942.1080708@jp.fujitsu.com>
	 <1350482209.28185.2.camel@misato.fc.hp.com>
	 <4977274.iWiO0dh4FZ@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 00:08 +0200, Rafael J. Wysocki wrote:
> On Wednesday 17 of October 2012 07:56:49 Toshi Kani wrote:
> > On Wed, 2012-10-17 at 10:26 +0900, Yasuaki Ishimatsu wrote:
> > > 2012/10/16 1:34, Toshi Kani wrote:
> > > > Removed lockable in struct acpi_device_flags since it is no
> > > > longer used by any code. acpi_bus_hot_remove_device() cannot
> > > > use this flag because acpi_bus_trim() frees up its acpi_device
> > > > object. Furthermore, the dock driver calls _LCK method without
> > > > using this lockable flag.
> > > > 
> > > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > 
> > > Looks good to me.
> > > Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > 
> > Thanks Yasuaki for reviewing!
> 
> Applied to linux-pm.git/acpi-next as v3.8 material.

Cool! Thanks Rafael!
-Toshi


> Thanks,
> Rafael



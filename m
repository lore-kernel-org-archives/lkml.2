Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab0HCPwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:52:45 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:33419 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757076Ab0HCPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:52:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VHaDI2J2TlYMHOZ8tIYNSMDxMBj6pjeX6efLG+OuNS+Xqqch7usA7nXoJ7W3jFtT/heUUxw5skB+46M1YVMoaHCWNhsaYJ0zzMtvfwoJAdITh1GFtc3oCyx34P7sRjLL;
Date: Tue, 3 Aug 2010 08:52:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Valdis.Kletnieks@vt.edu
Cc: Jeff Roberson <jroberson@jroberson.net>, linux-kernel@vger.kernel.org,
        aaronp@clustrix.com
Subject: Re: PCI-E Link training bug
Message-ID: <20100803085239.6766fb0e@virtuousgeek.org>
In-Reply-To: <60320.1280838641@localhost>
References: <alpine.BSF.2.00.1008030030430.1414@desktop>
	<60320.1280838641@localhost>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 08:30:41 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Tue, 03 Aug 2010 00:36:35 -1000, Jeff Roberson said:
> 
> > At least one intel chipset will occasionally negotiate a 4x link for an 8x 
> > device in an 8x port.  It is a known errata in the 5400 mch.  
> 
> Can this get wrapped in some sort of 'if (chipset == MCH5400)'?  There's no
> sense in adding an entire second of delay going around this loop 4 times when
> it's a valid config on a non-5400 chipset.

Yeah, it would be good to limit it to affected chipsets.  Also, please
post it to linux-pci@vger.kernel.org as well, and cc me, and we'll get
the fix in quickly.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

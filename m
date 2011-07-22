Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1GVQES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:04:18 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52513 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751631Ab1GVQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:04:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pGKv7EN7iPvNxnH9LtjbhBVulUG2ujR0xxAs0Sw6JtmztJ/Ttnv+CabcDjkudOCst7Hh6LjWR5OVIKpKBuwY+qd+Hoy5ev+uJo5No5UzW3RWgeUon/dGIlWkf+zCTd+Y;
Date: Fri, 22 Jul 2011 09:04:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, zajec5@gmail.com,
        linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 22 (bcma)
Message-Id: <20110722090414.4e3d80a5.rdunlap@xenotime.net>
In-Reply-To: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
References: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 16:42:37 +1000 Stephen Rothwell wrote:

> Hi all,

(similar to a report from July 16:)

linux-next-20110722/drivers/bcma/driver_pci.c:175: error: 'SSB_PCICORE_BFL_NOPCI' undeclared (first use in this function)

This build error happens whether CONFIG_PCI is enabled or disabled (unlike
what I stated on July 16).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

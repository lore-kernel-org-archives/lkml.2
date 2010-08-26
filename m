Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab0HZJus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:50:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:44222 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0HZJur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:50:47 -0400
Subject: Re: [PATCH RFC 1/1] MISC: Broadcom BCM4751 GPS driver
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Pavel Machek <pavel@ucw.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@kernel.org" <akpm@kernel.org>
In-Reply-To: <20100825060704.GA1578@ucw.cz>
References: <1282572026-14905-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1282572026-14905-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <20100825060704.GA1578@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 26 Aug 2010 12:31:15 +0300
Message-ID: <1282815075.14489.249.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2010 09:31:08.0310 (UTC) FILETIME=[69D5E360:01CB4501]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Wed, 2010-08-25 at 08:07 +0200, ext Pavel Machek wrote:
> On Mon 2010-08-23 17:00:26, Matti J. Aaltonen wrote:
> > Driver for Broadcom BCM4751 GPS chip.
> 
> 
> Uhuh. Tell us more... like what's the interface to userspace? NMEA
> data over char device?
>                                                                 Pavel

The interface to user space is MEIF data over a char device. Something
about MEIF can be found at

http://www.forum.nokia.com/info/sw.nokia.com/id/b265d3aa-8198-4eb0-a0e3-077748ccea40/MEIF_Specification_License.pdf.html

Best Regards,
Matti A.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1CKPCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:02:43 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36406 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751553Ab1CKPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:02:38 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+LWhsqkGSLygRpFO6cwiv4bTVy4+ns+k08mnZRIo
	0HAWcQtYMWE9TO
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 00/29] 2.6.37.4-stable review
Date: Fri, 11 Mar 2011 16:02:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-aptosid-686; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
References: <20110310235548.GA10103@kroah.com>
In-Reply-To: <20110310235548.GA10103@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111602.26977.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 11 March 2011, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.37.r release.
> There are 29 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by Saturday, March 12, 24:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.4-rc1.gz

This seems to be still missing on kernel.org, is there an issue with 
the mirroring?

$ LANG= wget kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.4-rc1.gz
--2011-03-11 16:01:24--  http://kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.37.4-rc1.gz
Resolving kernel.org... 130.239.17.4, 149.20.20.133, 199.6.1.164, ...
Connecting to kernel.org|130.239.17.4|:80... connected.
HTTP request sent, awaiting response... 404 Not Found
2011-03-11 16:01:24 ERROR 404: Not Found.

Regards
	Stefan Lippers-Hollmann

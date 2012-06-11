Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab2FKTox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:44:53 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:5000 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab2FKTow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:44:52 -0400
Message-ID: <1339443890.30984.96.camel@x61.thuisdomein>
Subject: RE: [uclinux-dist-devel] blackfin: how is the I-pipe code supposed
 to	be built?
From: Paul Bolle <pebolle@tiscali.nl>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "philippe.gerum@xenomai.org" <philippe.gerum@xenomai.org>
Date: Mon, 11 Jun 2012 21:44:50 +0200
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D170235830B4@NWD2CMBX1.ad.analog.com>
References: <1339365045.30984.78.camel@x61.thuisdomein>
	 <DB904C5425BA6F4E8424B3B51A1414D170235830B4@NWD2CMBX1.ad.analog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 11 Jun 2012 19:44:51.0363 (UTC) FILETIME=[AAA81F30:01CD480A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sonic,

On Sun, 2012-06-10 at 23:05 -0400, Zhang, Sonic wrote:
> The IPIPE patch is part of the ADEOS real time kernel patch. The
> common part of this patch hasn't been merged into mainline by the
> maintainer Philippe Gerum, although the Blackfin architecture part
> was. The relative Kbuild support and Kconfig symbols are defined in
> the ADOES common patch.

What's the point of having code in the mainline tree, for over three
years, without any Kbuild or Kconfig support?  


Paul Bolle


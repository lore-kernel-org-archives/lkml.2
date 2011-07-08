Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1GHJwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:52:53 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:55786 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab1GHJwu (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 8 Jul 2011 05:52:50 -0400
Message-Id: <4E17600E020000230002F274@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Fri, 08 Jul 2011 03:52:46 -0600
From: "Joey Lee" <jlee@novell.com>
To: <kengyu@canonical.com>
Cc: <ike.pan@canonical.com>, <kent.lin@canonical.com>, <sylee@canonical.com>,
        <vanhoof@canonical.com>, <mjg59@srcf.ucam.org>,
        <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 2/2] ideapad-laptop: Handle the App-controlled RF
 event
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
 <1309268154-6872-2-git-send-email-kengyu@canonical.com>
 <20110707151118.GB15366@srcf.ucam.org>
In-Reply-To: <20110707151118.GB15366@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keng-Yu, 

於 四，2011-07-07 於 16:11 +0100，Matthew Garrett 提到：
> On Tue, Jun 28, 2011 at 02:35:54PM +0100, Keng-Yu Lin wrote:
> 
> > On Linux, there is no such application. This patch implements
> > a toggle for all RF devices through accessing the EC I/O ports.
> 
> Sure there is. Either the kernel can handle it via rfkill-input, or 
> rfkilld can look after it. Please don't add your own implementation.
> 

Welcome to use urfkill deaemon:
http://www.freedesktop.org/wiki/Software/urfkill


Thank's a lot!
Joey


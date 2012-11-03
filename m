Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2KCWkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:40:46 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63234 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019Ab2KCWko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:40:44 -0400
Message-ID: <1351982441.1434.5.camel@x61.thuisdomein>
Subject: Re: [PATCH 8/9] isdn: Remove unused variable causing a compile
 build warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Date: Sat, 03 Nov 2012 23:40:41 +0100
In-Reply-To: <1351980150-24145-9-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
	 <1351980150-24145-9-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Nov 2012 22:40:41.0740 (UTC) FILETIME=[4111A4C0:01CDBA14]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 23:02 +0100, Lee Jones wrote:
> This patch fixes:
> drivers/isdn/i4l/isdn_common.c: In function ‘isdn_ioctl’:
> drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ‘s’ [-Wunused-variable]

Did you have CONFIG_NETDEVICES not set in this build?


Paul Bolle


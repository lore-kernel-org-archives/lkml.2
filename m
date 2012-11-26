Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2KZJmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:42:02 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:54321 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751876Ab2KZJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:42:00 -0500
Message-ID: <1353922918.1420.46.camel@x61.thuisdomein>
Subject: Re: [PATCH] ewrk3: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Nov 2012 10:41:58 +0100
In-Reply-To: <CAFLxGvyfH3WdNpsGzV2OgvyT_8hu4U03+HEuv3u9DvSkOmNBtA@mail.gmail.com>
References: <1353759165.1420.33.camel@x61.thuisdomein>
	 <CAFLxGvyfH3WdNpsGzV2OgvyT_8hu4U03+HEuv3u9DvSkOmNBtA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2012 09:41:58.0205 (UTC) FILETIME=[472C3ED0:01CDCBBA]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-25 at 11:45 +0100, richard -rw- weinberger wrote:
> > While we're touching this code also drop an outdated comment, that
> > should have been dropped with the patch named "MODULE_PARM conversions"
> > from early 2005.
> 
> Please send this change as an additional patch.

Sure. Although it will be a trivial patch I suppose it's easiest for
everyone if I still send it to netdev (and not to trivial, which
normally handles stuff like that).


Paul Bolle   



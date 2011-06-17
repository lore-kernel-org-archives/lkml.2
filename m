Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab1FQOv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:51:28 -0400
Received: from mail.solarflare.com ([216.237.3.220]:28576 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245Ab1FQOuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:23 -0400
Subject: Re: [PATCH v2] net/r8169: update the new parser for the new
 firmware
From: Ben Hutchings <bhutchings@solarflare.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: hayeswang <hayeswang@realtek.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110617125300.GA2193@electric-eye.fr.zoreil.com>
References: <1308109531-31698-1-git-send-email-hayeswang@realtek.com>
	 <20110616225904.GA2064@electric-eye.fr.zoreil.com>
	 <8AC7DE11560749B895F99EBA7D42AA49@realtek.com.tw>
	 <20110617063948.GA2146@electric-eye.fr.zoreil.com>
	 <1308313364.11457.63.camel@localhost>
	 <20110617125300.GA2193@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 17 Jun 2011 15:50:19 +0100
Message-ID: <1308322219.2831.1.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2011 14:50:23.0137 (UTC) FILETIME=[E2DCC910:01CC2CFD]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18204.005
X-TM-AS-Result: No--17.464000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-17 at 14:53 +0200, Francois Romieu wrote:
> Ben Hutchings <bhutchings@solarflare.com> :
> [...]
> > I thought the idea of embedding a version here was to be able to report
> > in in get_drvinfo, not to print it on load.
> 
> Reporting the version for the new firmware format through ethtool is
> currently hacked on.
> 
> Do you want the load time version / format messages removed ?
>
> I think they can be of some use - at least temporarily - but I won't mind
> removing them now.

I don't care one way or the other.  But it's more important to report
the version through get_drvinfo.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


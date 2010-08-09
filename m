Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0HIGuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:50:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49520 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0HIGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:49:59 -0400
Date: Mon, 9 Aug 2010 08:49:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: viresh kumar <viresh.kumar@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
Message-ID: <20100809064957.GB16661@pengutronix.de>
References: <4C5F9B25.8080401@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C5F9B25.8080401@st.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 09, 2010 at 11:37:33AM +0530, viresh kumar wrote:
> Hello,
> 
> Mail server in ST has recently changed and now we have Microsoft
> exchange server. We are using thunderbird as mail client.
> What we observed with this server is that patch are broken now while
> sending as well as receiving. Tabs are replaced by spaces and may
> be some other too which we haven't observed.
unlucky you.
 
> Has anybody found a solution to this kind of issues? Are there any
> workarounds possible?
git.git has some tips for thunderbird, see

	http://git.kernel.org/?p=git/git.git;a=blob;f=Documentation/SubmittingPatches;hb=HEAD

and look for the section titled "Thunderbird" (small surprise).

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

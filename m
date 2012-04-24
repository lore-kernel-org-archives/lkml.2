Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2DXDdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 23:33:04 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:52083 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508Ab2DXDdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 23:33:01 -0400
Message-ID: <4F961E7F.1020303@st.com>
Date: Tue, 24 Apr 2012 09:01:11 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: viresh kumar <viresh.linux@gmail.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        spear-devel <spear-devel@list.st.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] i2c: designware: Add clk_{un}prepare() support
References: <caa4a0645f80f199b31ec16de37a5c4c9c67a6fa.1334652570.git.viresh.kumar@st.com> <b562073871c8c3c13a1f59698f69cfdf65db3b5a.1334662366.git.viresh.kumar@st.com> <20120422172611.GA15041@pengutronix.de> <CAOh2x=mHS9h6kHxw2of-XWTtv35-SHRRno9Jdkb_3HuDoAovAg@mail.gmail.com> <20120422183806.GB24810@pengutronix.de>
In-Reply-To: <20120422183806.GB24810@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/2012 12:08 AM, Wolfram Sang wrote:
> Okay, thanks, both applied to next. If you mention dependencies somewhere
> when submitting, that might speed things, a tiny bit at least.

I normally do this. But forgot it this time myself too, that this patch
had a dependency :(

-- 
viresh

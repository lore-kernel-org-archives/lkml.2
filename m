Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2BXIdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 03:33:18 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53116 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab2BXIdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 03:33:17 -0500
Date: Fri, 24 Feb 2012 00:33:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: shawn <shawnlandden@gmail.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, Florian Echtler <floe@butterbrot.org>,
        linux-input@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
        deepak.sikri@st.com, vipulkumar.samar@st.com, amit.virdi@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: Mimo 720 input 180 deg off, e2i Re: [PATCH] Input:
 usbtouchscreen: add support for Data Modul EasyTouch TP 72037
Message-ID: <20120224083311.GC18291@core.coreip.homeip.net>
References: <1df92b173fb58c4b6d3091c3eb94d53bf03cfa9e.1330061754.git.viresh.kumar@st.com>
 <1330064583.2154.340.camel@ssd-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330064583.2154.340.camel@ssd-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 10:23:03PM -0800, shawn wrote:
> As I see you working on the same file I was working on----what would you
> think about a module-wide option in usbtouchscreen.c to rotate input
> handling by 180 degrees?
> 
> The mimo 720 uses the same e2i but seems to (at least in my unit) have
> its inputs rotated 180 deg relative to that of the mimo 740

I think canonical way of integrating touchscreen is with tslib on top of
evdev interface and leave coordinates transformation to tslib filters.

Thanks.

-- 
Dmitry

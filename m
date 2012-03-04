Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab2CDWK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:10:58 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46055 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2CDWJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:09:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.torokhov@gmail.com designates 10.68.225.231 as permitted sender) smtp.mail=dmitry.torokhov@gmail.com; dkim=pass header.i=dmitry.torokhov@gmail.com
Date: Sun, 4 Mar 2012 10:42:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Viresh Kumar <viresh.kumar@st.com>, linux-input@vger.kernel.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        viresh.linux@gmail.com, bhavna.yadav@st.com, vincenzo.frascino@st.com,
        mirko.gardi@st.com, salvatore.dedominicis@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Input: usbtouchscreen: add support for Data Modul
 EasyTouch TP 72037
Message-ID: <20120304184223.GG27647@core.coreip.homeip.net>
References: <ef63b19a6f667b4ffc22f0bacfda60d9e53fcba1.1330505561.git.viresh.kumar@st.com>
 <4F4E828F.2060105@gmx.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4E828F.2060105@gmx.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 08:54:55PM +0100, Daniel Ritz wrote:
> On 2012-02-29 11:07 , Viresh Kumar wrote:
> > From: Armando Visconti <armando.visconti@st.com>
> > 
> > The Data Modul TP 72037 EasyTouch controller is derived from EGALAX
> > controller and is capable of detecting dual contacts. Packets can be 5
> > bytes or 10 bytes long, depending whether one or two contacts are
> > detected. Format is same as EGALAX touch controller, but with x and y
> > coordinates inverted.
> > 
> > Signed-off-by: Armando Visconti <armando.visconti@st.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

...

> 
> Looks good, thanks.
> 
> Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
> 

Applied, thanks everyone.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab3AIMhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 07:37:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60134 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3AIMhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 07:37:04 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Loic PALLARDY <loic.pallardy@st.com>
CC: Tony Lindgren <tony@atomide.com>,
        Loic PALLARDY STE <loic.pallardy-ext@stericsson.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Gutierrez, Juan" <jgutierrez@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>, Tejun Heo <tj@kernel.org>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        "Anna, Suman" <s-anna@ti.com>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/9] mailbox: OMAP: introduce mailbox framework
Thread-Topic: [PATCH 1/9] mailbox: OMAP: introduce mailbox framework
Thread-Index: AQHN3SJyVkNHHwjuo0Kw3VTcOGqtQJgea4WAgAQvkQCAAHt0MP//pckAgB5OCbD//6kngIAAXVuA
Date: Wed, 9 Jan 2013 12:34:44 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433ECDD9BD@DBDE01.ent.ti.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
 <1355836212-17956-2-git-send-email-loic.pallardy-ext@stericsson.com>
 <20121218165909.GF4989@atomide.com> <50D423C2.3090009@st.com>
 <B5906170F1614E41A8A28DE3B8D121433EC9CF77@DBDE01.ent.ti.com>
 <50D43FA4.8090000@st.com>
 <B5906170F1614E41A8A28DE3B8D121433ECDD8C1@DBDE01.ent.ti.com>
 <50ED62B3.50000@st.com>
In-Reply-To: <50ED62B3.50000@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.119]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 17:59:39, Loic PALLARDY wrote:
> Hi Vaibhav,
> 
> On 01/09/2013 01:11 PM, Bedia, Vaibhav wrote:
> > Hi Loic,
> >
> > On Fri, Dec 21, 2012 at 16:23:24, Loic PALLARDY wrote:
> >>
> >>
> >> On 12/21/2012 11:49 AM, Bedia, Vaibhav wrote:
> >>> On Fri, Dec 21, 2012 at 14:24:26, Loic PALLARDY wrote:
> >>>>
> >>> I have a few patches which are dependent on this patch series.
> >>> Could you please keep me in cc for the future versions.
> >>>
> >> Sure, I'll.
> >>
> >
> > When do you plan to post an updated version of these patches?
> I'm synchronizing with Omar to include TI RPMsg and tidspbridge patches 
> in next update.
> So I plan update for end of the week, beginning of next week.
> 

Ok. Thanks.

Regards,
Vaibhav

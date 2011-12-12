Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1LLLbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 06:31:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:50771 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1LLLbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 06:31:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="85390100"
Date: Mon, 12 Dec 2011 12:36:17 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Rabin Vincent <rabin@rab.in>, Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 0/2] mfd/stmpe: Add SPI interface support
Message-ID: <20111212113617.GA13952@sortiz-mobl>
References: <cover.1320735864.git.viresh.kumar@st.com>
 <CAH+eYFAsLVU8A=m1Y1xm2YDRXhL1EGzxB-OcNQNd+w0tjMBZPA@mail.gmail.com>
 <4EBCF8FC.5020504@st.com>
 <CAH+eYFCvoy2eubAQkXROZVC7eNph58ohtdsP1pETLuS-6QExtQ@mail.gmail.com>
 <4EBD08E7.3080608@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBD08E7.3080608@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Fri, Nov 11, 2011 at 05:07:11PM +0530, Viresh Kumar wrote:
> On 11/11/2011 5:02 PM, Rabin Vincent wrote:
> > On Fri, Nov 11, 2011 at 15:59, Viresh Kumar <viresh.kumar@st.com> wrote:
> >> On 11/11/2011 3:13 PM, Rabin Vincent wrote:
> >>> Could you instead convert stmpe to use the register map API, and then
> >>> add the SPI interface?  Converting to regmap should both simplify the
> >>> existing code as well as make it possible to add the second interface
> >>> with fewer lines of code.
> >>
> >> Sorry Rabin, but i couldn't get your comment completely. :(
> >> Can you please spend few lines on "what do you mean by register map API"?
> > 
> > drivers/base/regmap, added in b83a313bf25 ("regmap: Add generic
> > non-memory mapped register access API").
> > 
> > Several MFDs are already using it (git grep regmap drivers/mfd/), and
> > patches to convert more are making the rounds on the lists.
> 
> Ok. Got it now. :)
> 
> Can we get this patchset pushed as it is and i will do this regmap stuff
> later in a separate patchset? Actually i am a bit busy currently with
> some other activities and can come back to it after some time.
Ok, but I really hope you will be able to get back at it. I applied your
patchset to my for-next branch for now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab1KKLdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:33:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37655 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1KKLdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:33:16 -0500
MIME-Version: 1.0
In-Reply-To: <4EBCF8FC.5020504@st.com>
References: <cover.1320735864.git.viresh.kumar@st.com> <CAH+eYFAsLVU8A=m1Y1xm2YDRXhL1EGzxB-OcNQNd+w0tjMBZPA@mail.gmail.com>
 <4EBCF8FC.5020504@st.com>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 11 Nov 2011 17:02:35 +0530
X-Google-Sender-Auth: zgZ0vOKzMAMH6_ngh9X-fk9NGTY
Message-ID: <CAH+eYFCvoy2eubAQkXROZVC7eNph58ohtdsP1pETLuS-6QExtQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] mfd/stmpe: Add SPI interface support
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 15:59, Viresh Kumar <viresh.kumar@st.com> wrote:
> On 11/11/2011 3:13 PM, Rabin Vincent wrote:
>> Could you instead convert stmpe to use the register map API, and then
>> add the SPI interface?  Converting to regmap should both simplify the
>> existing code as well as make it possible to add the second interface
>> with fewer lines of code.
>
> Sorry Rabin, but i couldn't get your comment completely. :(
> Can you please spend few lines on "what do you mean by register map API"?

drivers/base/regmap, added in b83a313bf25 ("regmap: Add generic
non-memory mapped register access API").

Several MFDs are already using it (git grep regmap drivers/mfd/), and
patches to convert more are making the rounds on the lists.

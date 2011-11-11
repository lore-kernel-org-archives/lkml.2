Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1KKK3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:29:34 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:45742 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab1KKK3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:29:33 -0500
Message-ID: <4EBCF8FC.5020504@st.com>
Date: Fri, 11 Nov 2011 15:59:16 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
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
Subject: Re: [PATCH 0/2] mfd/stmpe: Add SPI interface support
References: <cover.1320735864.git.viresh.kumar@st.com> <CAH+eYFAsLVU8A=m1Y1xm2YDRXhL1EGzxB-OcNQNd+w0tjMBZPA@mail.gmail.com>
In-Reply-To: <CAH+eYFAsLVU8A=m1Y1xm2YDRXhL1EGzxB-OcNQNd+w0tjMBZPA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 3:13 PM, Rabin Vincent wrote:
> Could you instead convert stmpe to use the register map API, and then
> add the SPI interface?  Converting to regmap should both simplify the
> existing code as well as make it possible to add the second interface
> with fewer lines of code.

Sorry Rabin, but i couldn't get your comment completely. :(
Can you please spend few lines on "what do you mean by register map API"?

-- 
viresh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0JDGDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 02:03:11 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:59406 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab0JDGDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 02:03:09 -0400
Message-ID: <4CA96DA1.7040301@st.com>
Date: Mon, 4 Oct 2010 11:31:05 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: viresh kumar <viresh.linux@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>
Subject: Re: [PATCH V2 62/69] ST SPEAr: Appending spear3** with global structures
References: <cover.1285933331.git.viresh.kumar@st.com>	<f4787f6021bf3a8c009595749894332c05e656df.1285933332.git.viresh.kumar@st.com> <AANLkTi=xNoG2T1Q2JqB7TH+O7AjW++UnSt1Q85VgPbzp@mail.gmail.com>
In-Reply-To: <AANLkTi=xNoG2T1Q2JqB7TH+O7AjW++UnSt1Q85VgPbzp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 09:51 PM, viresh kumar wrote:
> Hello everybody,
> 
> I have used an latest patch on git for sending this patch series. I
> think there is some bug
> there, due to which all of you have received some mails which are not
> intended for all of you.
> There was a bugfix in git which enables to send mail to "recipients
> mentioned in TO field", of patch
> itself.
> 
> After creating patches (with git format-patch ---), i have added To
> and CC lists in patches.
> But when i sent patches the TO field was carried away in later patches
> too. So due to this
> all patches send after rtc patches have following recipients added:
> rtc-linux@googlegroups.com,
> a.zummo@towertech.it. Similarly for other patches too.
> 

Hello,

Should i resend my patches (with correct list of people in To:)??

-- 
viresh

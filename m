Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0JAQVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:21:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36924 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0JAQVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gRvNtveYRNijIMgDDMezzS9Cm+BZMIcu/OkUJvMEGbK/5hQCq0I5jbbJ7Ly6IeLO0j
         dcIkRD5KCm6Fil53JBw0QdsqpfIg5rDgLC36wPlO9f13d+O3gDgnEKgOn6YZSf6lzTCN
         SQLue+7ueogcht6bvqU7YeVNXORSAkhPmcXXQ=
MIME-Version: 1.0
In-Reply-To: <f4787f6021bf3a8c009595749894332c05e656df.1285933332.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
	<f4787f6021bf3a8c009595749894332c05e656df.1285933332.git.viresh.kumar@st.com>
Date: Fri, 1 Oct 2010 21:51:06 +0530
Message-ID: <AANLkTi=xNoG2T1Q2JqB7TH+O7AjW++UnSt1Q85VgPbzp@mail.gmail.com>
Subject: Re: [PATCH V2 62/69] ST SPEAr: Appending spear3** with global structures
From: viresh kumar <viresh.linux@gmail.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: pratyush.anand@st.com, vipulkumar.samar@st.com, bhupesh.sharma@st.com,
        armando.visconti@st.com, vipin.kumar@st.com, shiraz.hashim@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 5:26 PM, Viresh KUMAR <viresh.kumar@st.com> wrote:
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  arch/arm/mach-spear3xx/include/mach/generic.h |  140 ++++++++++++------------
>  arch/arm/mach-spear3xx/spear300.c             |   42 ++++----
>  arch/arm/mach-spear3xx/spear300_evb.c         |   43 ++++----
>  arch/arm/mach-spear3xx/spear310.c             |   16 ++--
>  arch/arm/mach-spear3xx/spear310_evb.c         |   37 ++++---
>  arch/arm/mach-spear3xx/spear320.c             |   32 +++---
>  arch/arm/mach-spear3xx/spear320_evb.c         |   50 +++++----
>  arch/arm/mach-spear3xx/spear3xx.c             |   20 ++--
>  arch/arm/plat-spear/include/plat/spi.h        |    2 +-
>  9 files changed, 193 insertions(+), 189 deletions(-)

Hello everybody,

I have used an latest patch on git for sending this patch series. I
think there is some bug
there, due to which all of you have received some mails which are not
intended for all of you.
There was a bugfix in git which enables to send mail to "recipients
mentioned in TO field", of patch
itself.

After creating patches (with git format-patch ---), i have added To
and CC lists in patches.
But when i sent patches the TO field was carried away in later patches
too. So due to this
all patches send after rtc patches have following recipients added:
rtc-linux@googlegroups.com,
a.zummo@towertech.it. Similarly for other patches too.

Once again sorry for this.

--
viresh

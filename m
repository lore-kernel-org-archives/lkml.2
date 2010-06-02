Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0FBIrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:47:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62801 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0FBIrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=FRI4Sl8SPnWsC58GgGCcAt/rhZ7bwUquZ8g/PTtulMK3Cv4IxyeD3dsKkMAx1qpVno
         TvdNMNCy8JQu4vVV86uouqabkS+MLJ8ihFPekmslzltO0+Zd9SGaRR4RrnrDSnrOHhT1
         fBBaHo+AxdYi9nb6YRWmuJIjY/ey/MBmiG+Ns=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1275409361.2091.27208.camel@rchatre-DESK>
References: <20100528180952.GC2405@tuxdriver.com>
	<AANLkTil8SLseSeq1M_Xg7P4AqMy3V_0jxc7by2Xuaqnb@mail.gmail.com>
	<1275409361.2091.27208.camel@rchatre-DESK>
Date: Wed, 2 Jun 2010 10:42:02 +0200
Message-ID: <AANLkTimo_CpVC0B99GMJtIllAye5Yqa5yiIAiFBY-pIN@mail.gmail.com>
Subject: Re: pull request: wireless-2.6 2010-05-28
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zheng, Jiajia" <jiajia.zheng@intel.com>,
       "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
       "Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 6:22 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Hi Sedat,
>
> On Sat, 2010-05-29 at 06:34 -0700, Sedat Dilek wrote:
>> Two people confirmed the patch in [2] fixes:
>> 1. iwlwifi-2.6 GIT master (commit f10a237c95abd6d64a3a24553bd1d3bcddd9108b)
>> 2. compat-wireless (2010-05-21)
>>
>> And it fixes also the above mentionned combination.
>
> We are working on getting this patch upstream. The version tested
> contains a significant amount of duplicated code as well as some cleanup
> code mixed in. It is thus not appropriate for an upstream submission at
> this time.
>

What do you mean by "upstream"?
upstream for me is Linus-tree (linux-2.6 GIT master).
Patches against iwlwifi-2.6 GIT trees are not very helpful in my case.

>> As a suggestion:
>> What about "copying" bug-reports (incl. its history) from IWL-BTS into
>> linux-wireless ML?
>> For example (dri-devel related) bug-reports from
>> bugzilla.freedesktop.org are "copied" into dri-devel ML.
>
> Pointing people to the bug report seems to work ok. What benefit does
> the above have?
>

[+] People - not subscribed to the BR - can follow "on change".
[-] Blow up linux-wireless ML?

- Sedat -

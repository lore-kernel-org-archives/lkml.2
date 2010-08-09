Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0HIGzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:55:54 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:51721 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754093Ab0HIGzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:55:52 -0400
Message-ID: <4C5FA66D.7060404@st.com>
Date: Mon, 9 Aug 2010 12:25:41 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.1
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <4C5FA35E.50309@gmail.com>
In-Reply-To: <4C5FA35E.50309@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/2010 12:12 PM, Justin P. Mattock wrote:
> On 08/08/2010 11:07 PM, viresh kumar wrote:
>> > Hello,
>> >
>> > Mail server in ST has recently changed and now we have Microsoft
>> > exchange server. We are using thunderbird as mail client.
>> > What we observed with this server is that patch are broken now while
>> > sending as well as receiving. Tabs are replaced by spaces and may
>> > be some other too which we haven't observed.
>> >
>> > Has anybody found a solution to this kind of issues? Are there any
>> > workarounds possible?
>> >
>
> still trying to figure this out with thunderbird.. but did notice in 
> Documentation/email-clients.txt and SubmittingPatches
> there's info about that(just haven't gotten around to reading use git 
> send-email for patches)
> 
> hope this helps.

I missed this information in my last mail. We are using git send-email for
sending patches. As patches will go through Microsoft exchange server only,
so they are broken.

viresh.

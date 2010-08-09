Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0HIG4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:56:49 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:56810 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755039Ab0HIG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:56:48 -0400
Message-ID: <4C5FA698.90904@st.com>
Date: Mon, 9 Aug 2010 12:26:24 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <20100809064957.GB16661@pengutronix.de>
In-Reply-To: <20100809064957.GB16661@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/2010 12:19 PM, Uwe Kleine-König wrote:
> Hello,
> 
> On Mon, Aug 09, 2010 at 11:37:33AM +0530, viresh kumar wrote:
>> > Hello,
>> > 
>> > Mail server in ST has recently changed and now we have Microsoft
>> > exchange server. We are using thunderbird as mail client.
>> > What we observed with this server is that patch are broken now while
>> > sending as well as receiving. Tabs are replaced by spaces and may
>> > be some other too which we haven't observed.
> unlucky you.
>  
>> > Has anybody found a solution to this kind of issues? Are there any
>> > workarounds possible?
> git.git has some tips for thunderbird, see
> 
> 	http://git.kernel.org/?p=git/git.git;a=blob;f=Documentation/SubmittingPatches;hb=HEAD
> 
> and look for the section titled "Thunderbird" (small surprise).

I missed this information in my last mail. We are using git send-email for
sending patches. As patches will go through Microsoft exchange server only,
so they are broken.

With previous server everything was working fine.

viresh.

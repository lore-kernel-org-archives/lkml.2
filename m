Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0HJJ1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:27:17 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:41587 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab0HJJ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:27:12 -0400
Message-ID: <4C611B47.4090709@st.com>
Date: Tue, 10 Aug 2010 14:56:31 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Gadiyar, Anand" <gadiyar@ti.com>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <20100809064957.GB16661@pengutronix.de>	<4C5FA698.90904@st.com>	<20100809090137.GP13165@mea-ext.zmailer.org> <4C5FCBE1.2080303@st.com> <5A47E75E594F054BAF48C5E4FC4B92AB032401D8F0@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB032401D8F0@dbde02.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2010 2:52 PM, Gadiyar, Anand wrote:
> viresh kumar wrote:
>> > On 8/9/2010 2:31 PM, Matti Aarnio wrote:
>>> > > On Mon, Aug 09, 2010 at 12:26:24PM +0530, viresh kumar wrote:
>>>>> > >> > 
>>>>> > >> > I missed this information in my last mail. We are using git send-email for
>>>>> > >> > sending patches. As patches will go through Microsoft exchange server only,
>>>>> > >> > so they are broken.
>>>>> > >> > 
>>> > > Let your boss complain to your IT keepers.
>>> > > "These are Machine-to-Machine messages, they must not be modified!"
>>> > > 
>>> > > 
>>> > > It would probably be "against corporate policy" to use gmail for these emails...
>>> > > 
>> > 
>> > We got one solution: Upgrade Exchange server to SP2.
>> > Lets see if our IT department does this upgradation.
>> > 
> Upgrading the Exchange server worked for us a couple of years ago. At least
> git-send-email works okay now, but Outlook is horribly broken.
> 
> You could use gmail/others and send externally. Adding an explicit
> "From :" line in the patch can still give you credits to your official
> email address.
> 

Thanks Anand.

Lets see if our IT support team manages to upgrade to SP2 or not.

viresh.

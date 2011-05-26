Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab1EZTaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:30:14 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:47956 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754886Ab1EZTaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:30:12 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: iT7ih2UVM1kfwPYSYbgjQbq3kp8AfNSSPwgAquATntebENj
 Sig62X40sXkofWJaNkXWFd1lkiN9N41xb5pZwV1QBu0kqScm8lCXY53QXx1S
 wGfpGMN0RSVIo71e6kblJPRQLtWik3okVIo4h7K23VXNi9oqj0zKt2wohqo8
 KTw_HsolhUljg6A7Ho58IBFNAqkyvY8Zp66aeEYh9gwIBpKXQKYbL.k1c7YD
 afkCgUoX.tlTEsdYs57GFCoaoRCZ2SrersDD7jjbLP8SB9eKeXaOH7uy_6g6
 wtb3ePowGimpEDcO1YTT7UfxZehnlPr9LrmO.UTjNbTWYSvoWP.gxGJA__tk
 7wcig8bueeZvSARGGdLEvXUA4X1dErzKYRA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DDEAA3F.3030008@schaufler-ca.com>
Date: Thu, 26 May 2011 12:30:07 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com> <20110518172552.6d482c7a.akpm@linux-foundation.org> <20110526060842.GA13933@localhost.ucw.cz> <4DDE80FE.7010005@schaufler-ca.com> <1306433514.24986.26.camel@localhost.localdomain> <20110526183849.GA4563@ucw.cz>
In-Reply-To: <20110526183849.GA4563@ucw.cz>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2011 11:38 AM, Pavel Machek wrote:
> On Thu 2011-05-26 14:11:54, David Safford wrote:
>> On Thu, 2011-05-26 at 09:34 -0700, Casey Schaufler wrote:
>>> On 5/25/2011 11:08 PM, Pavel Machek wrote:
>>>> ...
>>>> Fourthly, is it likely to find its way to the next cellphone I buy,
>>>> and will it prevent me from rooting it?
>>> That will of course depend on the phone vendor. You are certainly
>>> going to be able to vote with your checkbook (digital wallet?) but
>>> odds are pretty good that should EVM prove effective it will be
>>> ubiquitous within the next five years on embedded devices.
> Hmm. But maybe it is more effective to vote with NAKs, now? It does
> not seem to have any non-evil uses.
>
> Phone vendors will play nasty tricks on us, but... why make it easy
> for them?

For one thing, it is probable that in the not-too-distant future
the phone will not be yours. Many service providers are moving in
the direction of zero-cost phones. The subscriber will pay the
monthly charge and the phone (smart or dumb) will be included in
the package. The difference between that and what is available
today will be a teeny tiny paragraph in the contract that says
that the free phone remains the property of the service provider.
Most people will not notice the difference. Consider this a
nasty trick if you want to. I expect that the average consumer
will love it because they will be spending 5 dollars/euros/pounds
a month less. Service providers will love it because the upgrade
and control choice will be theirs.

There is nothing evil about maintaining the owner's control over
the device. The fact that the device is in a user's hand does
not transfer ownership to the user.

Welcome to computers in the 21st century.


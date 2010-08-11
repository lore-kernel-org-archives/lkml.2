Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0HKLn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 07:43:58 -0400
Received: from mout.perfora.net ([74.208.4.194]:53396 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab0HKLn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 07:43:57 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 07:43:57 EDT
Message-ID: <4C628BC7.4020301@woutersimons.org>
Date: Wed, 11 Aug 2010 13:38:47 +0200
From: Wouter Simons <lkml@woutersimons.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@st.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com>	<AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com>	<4C624AE1.30504@st.com> <AANLkTi=SnPm7H75C7ycUH-GzENEDKWtncvLqeEVoEMQm@mail.gmail.com> <4C62812D.50300@st.com>
In-Reply-To: <4C62812D.50300@st.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:VbQWavxe0AHVSMyS+BBy+GrD0BiAQESFGuHF0Hu4KrI
 FsxBib5iQbuQtqZOMDE/vPDCDpVcrz3GnPKq+gj9dnxhX9lTf8
 WxJrsF/agzpa1iD+/ip9qk9KNOC17sbIu1TSHoWhmxDSYniTQN
 VY7PRec8jxQvhXpRH/M/0ssAGBTZVAYU9gzcShAv9NqayLAB1S
 ih29i0RRRzsEI0Oz1NZxYLREJ77Zq/bJwWMqU/PD2c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 12:53 PM, viresh kumar wrote:
> I couldn't find preformat. Is this same as plain text? If so i have tried it.
> I am not facing problem while writing mails from thunderbird but while receiving
> patches on thunderbird.

My thunderbird with default settings does not replace tabs with spaces. 
Perhaps the difference between outlook and thunderbird has to do with 
the method of connecting? On thunderbird you probably use IMAP to get 
your email from exchange, the IMAP system is horrible on exchange.

I suspect it has to do with the implementation of rules regarding 
spaces. The conformance documentation [1] of MS does not detail this 
sufficiently, but I am pretty sure that if you use an alternate mail 
client you will see the spaces replaced also when connecting through IMAP.

[1] http://msdn.microsoft.com/en-us/library/ee624585%28v=EXCHG.80%29.aspx

Wouter

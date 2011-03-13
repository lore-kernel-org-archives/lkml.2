Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1CMRQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 13:16:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43519 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755173Ab1CMRP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 13:15:57 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19qNxBPZkJqq8eqUY2tvffFLZh63MIjQDoJ5fxNpU
	eq7dS4eE8qA5If
Message-ID: <4D7CFBC7.2060109@gmx.de>
Date: Sun, 13 Mar 2011 18:15:51 +0100
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] viafb: kill lcd_panel_id
References: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>	<1299964979-3391-2-git-send-email-FlorianSchandinat@gmx.de> <m3hbb7xaup.fsf@pullcord.laptop.org>
In-Reply-To: <m3hbb7xaup.fsf@pullcord.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Chris Ball schrieb:
> Hi Florian,
> 
> On Sat, Mar 12 2011, Florian Tobias Schandinat wrote:
>> This patch removes all internal uses of another mostly artificial
>> value. It does duplicate the information of the maximum resolution and
>> it is not flexible as only a few resolutions exist. Hence it is better
>> to remove it and clean the mess up.
>> No runtime change expected.
>>
>> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> 
> We're passing viafb_lcd_panel_id at boot-time on OLPC XO-1.5.
> Won't this break boot for us, and anyone else who needs to use it?

No need to worry. The external interface is kept for compatibility, only the 
internal uses are replace by panel hres/vres which contain the same information 
but are more generic.
I have not yet tested it on OLPC as I did not have the time to compile a new 
kernel for it, but as it works on my VX900 laptop which also uses the 
viafb_lcd_panel_id setting it should be fine.


Thanks,

Florian Tobias Schandinat


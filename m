Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2DGLsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 07:48:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34153 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752672Ab2DGLsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 07:48:16 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18m3Hhl1s8mvPro26kBG+qRlns5OYE8FXlkpzZGh7
	7fUYAP8mJjnD0b
Message-ID: <4F802974.4000405@gmx.de>
Date: Sat, 07 Apr 2012 11:48:04 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kyrofb: fix on x86_64
References: <201203212336.55396.linux@rainbow-software.org> <20120322000104.GB26543@linux-sh.org> <201204071338.30521.linux@rainbow-software.org>
In-Reply-To: <201204071338.30521.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 11:38 AM, Ondrej Zary wrote:
> On Thursday 22 March 2012 01:01:05 Paul Mundt wrote:
>> On Wed, Mar 21, 2012 at 11:36:50PM +0100, Ondrej Zary wrote:
>>> kyrofb is completely broken on x86_64 because the registers are defined
>>> as unsigned long. Change them to u32 to make the driver work.
>>> Tested with Hercules 3D Prophet 4000XT.
>>>
>>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>>
>> Looks fine to me.
>>
>> Acked-by: Paul Mundt <lethal@linux-sh.org>
> 
> When will this go in?

Probably between -rc2 and -rc3. I've already applied this in my private
tree, I just needed a few days off after the last merge window.


Best regards,

Florian Tobias Schandinat

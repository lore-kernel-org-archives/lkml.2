Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1FCTsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:48:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46210 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1FCTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:48:12 -0400
Message-ID: <4DE93A77.1070404@canonical.com>
Date: Fri, 03 Jun 2011 15:48:07 -0400
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: linux-kernel@vger.kernel.org, rydberg@euromail.se, jkosina@suse.cz,
        linux-input@vger.kernel.org
Subject: Re: [regression] Apple Magic Mouse stalls
References: <201105281006.33763.edt@aei.ca>
In-Reply-To: <201105281006.33763.edt@aei.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2011 10:06 AM, Ed Tomlinson wrote:
> Hi
> 
> I've been having fun with bluetooth in .38-rc.  My adapter was old (bt 1.1) and the bluetooth stack was having 'fun' with it.
> Got tired of that a got asus doggle that supports 2.1+EDR.  Then I tried to use my magic mouse.  It works for a few
> minutes and then stalls.  The stalls seem to be related to touches.  If I am careful only to touch with one finger it
> seems to work.  It usually works with two fingers, with three it stalls.   Running hcidump sometimes lists a last 
> packet with a dlen of 35 when it stalls.  Powering it on an off reset things 
> 
>> ACL data: handle 21 flags 0x02 dlen 27
>     L2CAP(d): cid 0x0041 len 23 [psm 0]
>> ACL data: handle 21 flags 0x02 dlen 27
>     L2CAP(d): cid 0x0041 len 23 [psm 0]
>> ACL data: handle 21 flags 0x02 dlen 27
>     L2CAP(d): cid 0x0041 len 23 [psm 0]
>> ACL data: handle 21 flags 0x02 dlen 35
>     L2CAP(d): cid 0x0041 len 31 [psm 0]
> 
> This was not a problem pre .38.  It started happening in .38-rc along with other bluetooth problems.  I figured the bt
> problem was the root cause - I was wrong.
> 
> This ring any bells?

Not for me... Nothing has changed in the driver that could cause such a
change, so if there is a regression it exists somewhere else in the stack.

Jiri, any thoughts?

-- Chase

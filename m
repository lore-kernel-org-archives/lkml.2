Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0FOG5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:57:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47268 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab0FOG5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:57:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C17244D.7010806@s5r6.in-berlin.de>
Date: Tue, 15 Jun 2010 08:57:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       Peter Stuge <peter@stuge.se>
Subject: Re: [PATCH 4/8]drivers:tmp.c Fix warning: variable 'rc' set but	not
 used
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com> <1276547208-26569-5-git-send-email-justinmattock@gmail.com> <21331.1276560832@localhost> <4C16E18F.9050901@gmail.com> <9275.1276573789@localhost> <4C16F9FC.2080905@gmail.com> <20100615052944.7746.qmail@stuge.se> <4C17169F.4060205@gmail.com>
In-Reply-To: <4C17169F.4060205@gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> On 06/14/2010 10:29 PM, Peter Stuge wrote:
>> Justin P. Mattock wrote:
>>> I have no manual in front of me. Did a quick google, but came up with
>>> (no hits) info on what that function does. grep showed too many entries
>>> to really see why/what this is.
>>
>> Check out the tool cscope. (Or kscope, if you prefer a GUI.)
> 
> thanks for this tool.. I think this is what I need.. running around not
> knowing what/where the manual is for a call is a bit daunting.

Similar to cscope/kscope but online:
http://lxr.free-electrons.com/
http://lxr.linux.no/linux

E.g. http://lxr.free-electrons.com/ident?i=transmit_cmd
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/

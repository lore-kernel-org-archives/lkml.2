Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0EHXYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 19:24:06 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55678 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0EHXYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 19:24:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE5F286.1020503@s5r6.in-berlin.de>
Date: Sun, 09 May 2010 01:23:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by default
References: <1273354364-6016-1-git-send-email-florian@mickler.org>	 <1273354778-6129-1-git-send-email-florian@mickler.org> <1273358674.704.77.camel@Joe-Laptop.home>
In-Reply-To: <1273358674.704.77.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2010-05-08 at 23:39 +0200, florian@mickler.org wrote:
>> If scm meta-information is used, only list people that signed-off or
>> acked or reviewed the code in question.
>>
>> after all it's called get_maintainer.pl and not
>> get_random_people_to_look_at_the_code.pl
> 
> Anyone that actually signs a patch is not "random".

Reported-by and tested-by signatures in the git history commit /are/ in
fact random WRT getting a list of handlers/ reviewers of a new patch. It
is more likely that reporters and testers cannot or/and do not want to
do anything about such a patch.  Such a mailing is called UBE.
-- 
Stefan Richter
-=====-==-=- -=-= -=--=
http://arcgraph.de/sr/

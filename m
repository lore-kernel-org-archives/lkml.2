Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab1IIIl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:41:26 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:39893 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1IIIlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:41:25 -0400
Subject: Re: [PATCH 3/3] typedef cleanup
Mime-Version: 1.0 (Apple Message framework v1250.2)
Content-Type: text/plain; charset=us-ascii
From: Chris Boot <bootc@bootc.net>
In-Reply-To: <20110909073025.GE17041@mwanda>
Date: Fri, 9 Sep 2011 10:21:45 +0200
Cc: Arvydas Sidorenko <asido4@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EFACD54B-A3ED-4B78-B06F-82A46A739829@bootc.net>
References: <1315166085-27984-1-git-send-email-asido4@gmail.com> <1315166085-27984-3-git-send-email-asido4@gmail.com> <A80909DB-416A-4E81-AEB9-1308366FC693@bootc.net> <20110909073025.GE17041@mwanda>
To: Dan Carpenter <error27@gmail.com>
X-Mailer: Apple Mail (2.1250.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 Sep 2011, at 09:30, Dan Carpenter wrote:

> On Thu, Sep 08, 2011 at 07:35:37PM +0200, Chris Boot wrote:
>> On 4 Sep 2011, at 21:54, Arvydas Sidorenko wrote:
>> 
>>> #ifndef uint64_t
>>> -typedef struct _uint64_t {
>>> +struct _uint64_t {
>>> 	uint32_t low_dw;
>>> 	uint32_t hi_dw;
>>> } uint64_t;
>>> #endif
>> 
>> This can't be right can it? You're changing a typedef into a
>> variable definition as far as I can see.
> 
> Yes.  You are right.  The "uint64_t" is a variable now so this patch
> is wrong.
> 
> (Or maybe you knew that and the question was rhetorical?  It's hard
> to tell over email.)

Dan,

Sorry, I had just come back well-watered from a nice meal last night! :-) Yes I realised that wasn't what you meant to do with your patch, sorry it came out the wrong way.

Without looking at the code I imagine you could remove the entire definition above, but that's just a guess.

HTH,
Chris

-- 
Chris Boot
bootc@bootc.net


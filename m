Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881Ab2HIOzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:55:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4238 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030553Ab2HIOy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:54:58 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=wom5GMh1gUkA:10 a=LzBzSxG1IzkA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=UcBkOE8_MxKiRTuxVVQA:9 a=CjuIK1q_8ugA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Date: Thu, 9 Aug 2012 10:54:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Ren, Cloud" <cjren@qca.qualcomm.com>
Cc: David Miller <davem@davemloft.net>, "joe@perches.com" <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>,
        "Huang, Xiong" <xiong@qca.qualcomm.com>,
        "hao-ran.liu@canonical.com" <hao-ran.liu@canonical.com>,
        "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
Message-ID: <20120809145454.GA21195@home.goodmis.org>
References: <6349D7A510622448B1BA0967850A8438013692CA@NASANEXD02D.na.qualcomm.com>
 <1344485382.2024.9.camel@joe2Laptop>
 <6349D7A510622448B1BA0967850A843801369364@NASANEXD02D.na.qualcomm.com>
 <20120808.231804.12694947300243733.davem@davemloft.net>
 <6349D7A510622448B1BA0967850A8438013693DD@NASANEXD02D.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6349D7A510622448B1BA0967850A8438013693DD@NASANEXD02D.na.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 06:49:25AM +0000, Ren, Cloud wrote:
> 
> Please calm down. I will follow rule of sending email from now on. Sorry for causing
> your trouble. Luis has ever asked joe for adding as a Signed-off-by. At that time joe agreed
> with it. If joe prefers his name not be listed as a Signed-off-by, I will respect his decision.
> alx driver is innocent. Please help review.  Thanks

I'm curious, did Luis ask on list or off? When I ask someone for a
Signed-off-by tag, I always ask them to post it to the list, even when
they have given it to me privately. I like others to see that someone
explicitly gave me their permission, as I would never add a Signed-off
tag for someone else.

The Signed-off tag has some legal bindings (all other tags are for
credit/info only). It is that person saying that the changes they made
to a patch are theirs and are giving the right to distribute it. It is
also used by those that take the changes and insert it into the
repository.

>From Documentation/SubmittingPatches:

  The sign-off is a simple line at the end of the explanation for the
  patch, which certifies that you wrote it or otherwise have the right to
  pass it on as an open-source patch.

Joe, If you actually modified part of the code in the patch, you do have
the right to add a signed-off-by tag. If you just made suggestions or
reviewed, then a 'Suggested-by' or 'Reviewed-by' tag would be more
appropriate.

  The Signed-off-by: tag indicates that the signer was involved in the
  development of the patch, or that he/she was in the patch's delivery
  path.

-- Steve


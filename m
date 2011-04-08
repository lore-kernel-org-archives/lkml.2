Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1DHPHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:07:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47115 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1DHPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 11:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t40aaax4Ur6CV25JommQ0yuSrWVno9nsRhE4HZrEG3LayWHS75sUjtpQYVzjs+quZS
         JlxLk8wrMUH4j0Y1jy/jj89gB8qDtY/Sv1CHAaieV9X1iFQxd/0r1A1Z04s1UkkEr478
         /3Q9wDWw6h2GB5BAo9h+JWYetofKn2jb6svuo=
Message-ID: <4D9F2499.1030803@gmail.com>
Date: Fri, 08 Apr 2011 08:07:05 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: trivial@kernel.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5 V2]arch:common:Makefile Remove unused config in the
 Makefile.
References: <1302219529-8864-1-git-send-email-justinmattock@gmail.com> <20110408073153.GA18601@pengutronix.de>
In-Reply-To: <20110408073153.GA18601@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 12:31 AM, Uwe Kleine-König wrote:
> Hi Justin,
>
> On Thu, Apr 07, 2011 at 04:38:49PM -0700, Justin P. Mattock wrote:
>> The patch below removes an unused config variable found by using a kernel
>> cleanup script.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> Acked-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
>> Acked-by: Jean-Christophe PLAGNIOL-VILLARD<plagnioj@jcrosoft.com>
>> ---
> Russell asked you to send this to his patch system.
> See http://www.arm.linux.org.uk/developer/patches/info.php for more info
> about that.
>
> Best regards
> Uwe
>


ahh... alright I will read up on that and resend..

Thanks!

Justin P. Mattock

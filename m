Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2CDTJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 14:09:08 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40326 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab2CDTJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 14:09:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.133.10 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F53BDCA.3030003@gmail.com>
Date: Sun, 04 Mar 2012 20:08:58 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        smatch@vger.kernel.org
Subject: Re: Smatch v1.56 released
References: <20120304180455.GA1003@mwanda> <1330886330.7070.22.camel@joe2Laptop>
In-Reply-To: <1330886330.7070.22.camel@joe2Laptop>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2012 07:38 PM, Joe Perches wrote:
> On Sun, 2012-03-04 at 21:04 +0300, Dan Carpenter wrote:
>> Smatch still produces a lot of false positives.  Also as bugs get
>> fixed in the kernel, the false positive to real bug ratio gets
>> worse and worse.  But it does find real bugs as well.
> 
> Perhaps a database of known false positives and a mechanism
> to use it to see only new instances could be created.

Yes, this is actually what xgcc has been doing. See [1] to see how to do
it more-or-less reliably.

[1] A system and language for building system-specific, static analyses,
Hallem, S. and Chelf, B. and Xie, Y. and Engler, D.

regards,
-- 
js

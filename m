Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab1EWWJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:09:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53274 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757708Ab1EWWJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:09:21 -0400
Subject: Re: [PATCH v5 00/21] EVM
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
In-Reply-To: <20110520185034.GA8920@mail.hallyn.com>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110520185034.GA8920@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 18:09:14 -0400
Message-ID: <1306188554.2732.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 13:50 -0500, Serge E. Hallyn wrote:
> Hi Mimi,
> 
> just fyi I think I'm done with the patches where my reviews might be
> useful.  I'll give them another look-over when you repost.  You said
> something about ltp testcases - please let me know if you'd like any
> help, otherwise if they're not yet upstream when you repost, please
> point me to them, and i'll build a test kernel and exercise it
> somewhere.
> 
> thanks,
> -serge

Thanks so much Serge for all the reviews!  In terms of the EVM ltp
testcases, I have some tests, but they make a number of assumptions,
like having an EVM key and a fully labeled system.  After re-posting,
I'll take a look into creating a set of EVM testcases, which don't
require a fully labeled system.

thanks,

Mimi


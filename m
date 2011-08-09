Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab1HIHGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 03:06:54 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:50999 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751140Ab1HIHGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 03:06:53 -0400
Message-ID: <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net>
In-Reply-To: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
Date: Tue, 9 Aug 2011 00:06:53 -0700
Subject: Re: running of out memory => kernel crash
From: "Randy Dunlap" <rdunlap@xenotime.net>
To: "Mahmood Naderan" <nt_mahmood@yahoo.com>, linux-mm@kvack.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:program running on server}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, August 8, 2011 11:53 pm, Mahmood Naderan wrote:
> Hi
> I have noticed that when the swap is disabled
>
> (either via swapoff or not defining any swap partition),
>
> then running out of memory can cause a kernel panic. 
>
> I wonder why the hungry application won't be killed
>
> upon a request for a resource that is not available?
> In that case, the problematic application will be killed
> only but what we see now is that the whole system is
> crashed.

Do you have any kernel log panic/oops/Bug messages?

[adding linux-mm mailing list]


-- 
~Randy


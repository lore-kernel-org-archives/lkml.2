Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab0FMTXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 15:23:33 -0400
Received: from www17.your-server.de ([213.133.104.17]:42607 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0FMTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 15:23:32 -0400
Message-ID: <DC0C730083854824867BF062E17E7FAA@hugo>
From: "Thomas Meyer" <thomas@m3y3r.de>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
References: <20100609183449.110905403@vyatta.com><1276152212.13438.4.camel@localhost> <20100611103053.26b6954e@nehalam>
In-Reply-To: <20100611103053.26b6954e@nehalam>
Subject: Re: [PATCH 0/8] floppy: cleanup patches
Date: Sun, 13 Jun 2010 19:23:28 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Windows Mail 6.0.6002.18197
X-MimeOLE: Produced By Microsoft MimeOLE V6.0.6002.18197
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----- 
From: "Stephen Hemminger" <shemminger@vyatta.com>
> On Thu, 10 Jun 2010 08:43:32 +0200
> Thomas Meyer <thomas@m3y3r.de> wrote:
> 
>> Am Mittwoch, den 09.06.2010, 11:34 -0700 schrieb Stephen Hemminger:
>> > When going through floppy driver addressing some of the timing
>> > bugs, I also saw these leftover things that ought to be cleaned up.
>> >   
>> 
>> With your patches applied on top of 2.6.34 I still get this timeout
>> while resuming from ram:
> 
> Not clear, did the problem occur before my patches?

Yes, the timeout occured before your patches, i.e. plain 2.6.34.

> The posted set
> of patches should not change visible functionalty or fix any observable
> bug. Floppy driver would be bug for bug the same.

I guess, it's okay then.

kind regards
thomas



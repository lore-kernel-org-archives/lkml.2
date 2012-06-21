Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2FUF7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:59:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62826 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2FUF7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:59:07 -0400
Subject: Re: How does SACK or FACK determine the time to start fast
 retransmition?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: LovelyLich <lovelylich@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAAA3+BpRQ24HED6a+yCF+A_q=vJ7nHexLJd1U+-50pb43MVa5w@mail.gmail.com>
References: <CAAA3+BpRQ24HED6a+yCF+A_q=vJ7nHexLJd1U+-50pb43MVa5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jun 2012 07:59:02 +0200
Message-ID: <1340258342.4604.3983.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 22:31 +0800, LovelyLich wrote:
> HI all,
>     When tcp uses reno as its congestion control algothim, it uses
> tp->sacked_out as dup-ack. When the third dup-ack(under default
> condition) comes, tcp will initiate its fast retransmition.
>     But how about sack ?

Some tcp experts out there only catch tcp related stuff if Subject
includes TCP.

You might resend your mail on netdev (not sure lkml will really help)
with following subject :

[RFC] tcp: How does SACK or FACK determine the time to start fast
retransmission?

To get more traction.



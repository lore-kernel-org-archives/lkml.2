Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2AYUDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:03:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64930 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2AYUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:03:35 -0500
Message-ID: <1327521811.2605.8.camel@edumazet-laptop>
Subject: Re: iproute2-2.6.38 + oif argument error
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ganesh Reddy K <ganeshreddyk@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, ganeshreddy <ganeshreddy@freescale.com>
Date: Wed, 25 Jan 2012 21:03:31 +0100
In-Reply-To: <CA+h4rtFMtprNyW2GH601TY9gBY1JTWK+Wktka-RzD8MQogK+zQ@mail.gmail.com>
References: <CA+h4rtFMtprNyW2GH601TY9gBY1JTWK+Wktka-RzD8MQogK+zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 26 janvier 2012 à 01:14 +0530, Ganesh Reddy K a écrit :
> Hello,
> 
> I am trying to exercise 'ip rules'  command with some configuration on
>  a PowerPC Processor. Version is iproute2-2.6.38
> 
> 
> I tried "ip rule add oif eth1 table 100"
> It  resulted with  error message "RTNETLINK answers: Invalid argument".
> 
> Can anybody tried this.
> 
> It is shown in the ip rule help all the possible options . Few of them
> are iif, oif.    iif option is working . No issue observed.   oif
> option is causing error.
> 
> 
> Can you please share any patch fixes to proceed further ?
> 

What is your kernel version ?



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2HDOv3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 10:51:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53506 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2HDOvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 10:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACS4u_zUF9T0rSsndhyVzgaauOBFJ4LTUeb432B1zg_oLHvTsg@mail.gmail.com>
References: <CACS4u_zUF9T0rSsndhyVzgaauOBFJ4LTUeb432B1zg_oLHvTsg@mail.gmail.com>
Date: Sat, 4 Aug 2012 16:51:24 +0200
Message-ID: <CAFLxGvxqj+-rf5twsMPk-pRQqzqsK8-MSsKaez9cwarPmyEqzw@mail.gmail.com>
Subject: Re: TCP Delayed ACK in FIN/ACK
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-2?Q?S=B3awek_Janecki?= <janecki@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 4, 2012 at 4:45 PM, Sławek Janecki <janecki@gmail.com> wrote:
> I have a node.js client (10.177.62.7) requesting some data from http
> rest service from server (10.177.0.1).
> Client is simply using nodejs http.request() method (agent=false).
> Client is on Ubuntu 11.10 box.
> Why client sends FIN ACK after 475ms? Why so slow? He should send FIN
> ACK immediately.
> I have many situations like this. About 1% of whole traffic is request
> with delayed FIN ACK.
> Cpu idle on the client is about 99%, so nothing is draining CPU.
> How to debug this? What could it be? Is there any sysctl option I need to tune?
> I think this behaviour is the Delayed ACK feature of RFC1122 TCP stack.
>
> Link to tcpdump picture (done on a client machine) :
> http://i48.tinypic.com/35cpogx.png
>
> Can you tell why kernel delayed that FIN/ACK.
> In tcpflow data there is exacly one ACK per packet comming from server.
> Why kernel delayed client FIN/ACK.
> It could avoid sending ACK every 'data' packet.
> But it choose to delay FIN/ACK?
> Is this possible? Is this a bug?
>
> I've also posted question on stackexchange:
> http://stackoverflow.com/questions/11711218/client-sends-delayed-fin-ack-500ms-to-server
>
> Please help.

CC'ing netdev.

-- 
Thanks,
//richard

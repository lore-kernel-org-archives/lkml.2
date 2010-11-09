Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab0KIFgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 00:36:07 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51177 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KIFgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 00:36:03 -0500
From: Varun Chandramohan <varunc@linux.vnet.ibm.com>
Organization: IBM
To: ranjith kumar <ranjithproxy@gmail.com>
Subject: Re: how to read one udp packet with more than one recvfrom() calls?
Date: Tue, 9 Nov 2010 11:05:55 +0530
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
In-Reply-To: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091105.56137.varunc@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try MSG_PEEK option.

Regards,
Varun 

On Monday, November 08, 2010 12:38:47 pm ranjith kumar wrote:
> Hi,
> 
> I  have implemented client and server programs using udp
> protocol(files are attached).
> UDP packet size is 500bytes.
> 
> I want to read these 500bytes in two calls to recvfrom(). First time
> reading 100bytes and second time 400bytes.
> How to do this?
> 
> When I tried to change the third argument of recvfrom(size_t len),
> from 500 to 100, first 100bytes are read correctly.
> But when I call recvfrom() second time with len=400, it is reading the
> first 400bytes of "next udp packet".
> Why? Isn't it possible to read one udp packet in two calls to
> recvfrom()/read()????
> 
> Thanks in advance.
> 

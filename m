Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0JNKnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:43:25 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:52553 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052Ab0JNKnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:43:24 -0400
Message-ID: <4CB6DEC4.4040408@cyconix.com>
Date: Thu, 14 Oct 2010 11:43:16 +0100
From: Tom Brown <sa212+emis@cyconix.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Question: how to copy to user space from a tasklet
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry to have to ask this here - I can't find any driver-specific 
newsgroup or mailing lists - are there any??]

I have a driver which needs to copy device data direct to user space 
from a tasklet. I need to do this because the device is continuously 
DMA'ing into user space, with no user intervention, so the user isn't 
waiting for data. In other words, I don't have any user-associated 
process to wake up.

This means that I have to somehow copy the data directly to the user 
from the tasklet, without sleeping, and without direct access to user 
context. Can someone tell me how to do this?

Thanks

Tom

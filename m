Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0G2Xls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:41:48 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45890 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0G2Xlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=MyB0Bwxxu9Zak7jr/A1+rMNGzqxcN3vaECWYpVd1/cuHMNd5JcSXq4lEQOTuMs5Rx9
         7rktbqWflLuR3YWyJbEBa6XDrBoRWMsZWYnGPFtM/Ll1YhmKPiG/37fT48E0ra501wdK
         QgDIceFe5x3kgchDIygzS0oLLr4p/ZK4/Oh80=
Message-ID: <4C5211D6.3000406@gmail.com>
Date: Fri, 30 Jul 2010 03:42:14 +0400
From: "Guram Z. Savinov" <savinov.guram@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Get interface MAC address in sys_accept4() syscall
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

in net/socket.c is syscall sys_accept4(). In it syscall I need to get 
MAC address of interface, from connection is come.
For example it is two interfaces eth0 and eth1. I want to know, from 
what interface connection is come to sys_accept4().
Please help me, how I can do it.

Thank's for attention for my question.

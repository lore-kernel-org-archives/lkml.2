Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab2GXIJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 04:09:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53930 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab2GXIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 04:08:43 -0400
Message-ID: <500E5808.1070607@gmail.com>
Date: Tue, 24 Jul 2012 01:08:40 -0700
From: bforce1729 <bforce1729@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Need to know the size of data send from Kernel to USer Ap
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am new to kernel programming so can anyone point me to the right 
forum/reply for the question below.

I would like to implement a character device and using a node of type 
character  read and write data. However I am not sure of the length of 
data from kernel which a user app will receive, so I would like to code 
safely. If the data exceeds the application gets killed.
Any idea or API to perform the task of knowing the data length when 
passing data to and fro from kernel to user level would be appreciated.

Kernel code:

                 copy_to_user(buff, kernel_msg, strlen(kernel_msg));

User App:
                 fd=open("./my_device",O_RDONLY);
ret=read(fd,buff,strlen(buf));                        //How can I know 
the size of buff, which would be sent/filled from kernel???

Regards
bforce

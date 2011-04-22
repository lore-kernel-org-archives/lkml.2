Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab1DVXJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:09:32 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50571 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab1DVXJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:09:31 -0400
Message-ID: <4DB20AA9.4080801@candelatech.com>
Date: Fri, 22 Apr 2011 16:09:29 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Debugging hung tasks?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am testing lots of NFS traffic against an over-loaded and slow file server.

I enabled the hung-task detection logic, and it's hitting after 180
seconds.

First:  Is there any valid reason to have funky NFS cause a hung task?

Second: Why doesn't the hung-task panic logic print the stack trace of
    the hung task?
    Is this an option that can be enabled?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


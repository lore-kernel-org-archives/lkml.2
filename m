Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab1EJSbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:31:39 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50632 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1EJSbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:31:38 -0400
Message-ID: <4DC98489.2060902@candelatech.com>
Date: Tue, 10 May 2011 11:31:37 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Fedora 14 not always going to run-level 3?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has anyone else noticed problems with 39-rc1+ sometimes not booting
into run-level 3?  It seems to just go directly to root console prompt
sometimes.  Seems it was easier to reproduce on -rc1 and early more
buggy kernels, for what that's worth..

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


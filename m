Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2FGWuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:50:40 -0400
Received: from mail.candelatech.com ([208.74.158.172]:53727 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab2FGWuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:50:39 -0400
Message-ID: <4FD1303E.1010002@candelatech.com>
Date: Thu, 07 Jun 2012 15:50:38 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.3.7+  'reboot' causes shutdown instead.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One one of our super-micro motherboard systems, when
we do a 'reboot', the system instead powers down.

This does not happen on the 3.0.32+ kernel.  The other systems we
have tried reboot find on the same 3.3.7+ kernel.

Any ideas on how to work around this or debug it further?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


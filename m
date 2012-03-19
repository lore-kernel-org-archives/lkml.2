Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032388Ab2CSSE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:04:56 -0400
Received: from mail.candelatech.com ([208.74.158.172]:54405 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab2CSSEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:04:54 -0400
Message-ID: <4F677546.4070500@candelatech.com>
Date: Mon, 19 Mar 2012 11:04:54 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Question on kernel-docs comment syntax.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to add some kdocs comment such that it creates a link
to another struct (in another file/subsystem).

  * @get_et_stats:  Ethtool API to get a set of u64 stats.
  *	See @ethtool_ops

The above does NOT appear to work as I would hope.

I've had no luck finding documentation for the syntax....
anyone have a pointer to a proper web page or document?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


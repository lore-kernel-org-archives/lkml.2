Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0CQK6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:58:52 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:57443 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab0CQK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:58:51 -0400
From: Frans Pop <elendil@planet.nl>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch] netpoll: warn when there are spaces in parameters
Date: Wed, 17 Mar 2010 11:58:47 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, amwang@redhat.com,
       davem@davemloft.net
References: <20100317101635.5948.23485.sendpatchset@localhost.localdomain>
In-reply-To: <20100317101635.5948.23485.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003171158.49549.elendil@planet.nl>
X-OriginalArrivalTime: 17 Mar 2010 10:58:49.0878 (UTC) FILETIME=[D30DF360:01CAC5C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> +               if (*cur == ' ' || *cur == '\t')
> +                       printk(KERN_INFO "%s: warning: white spaces"
> +                                       "are not allowed.\n", np->name);
> 

The term "white spaces" not correct. Please change the message to
"whitespace is not allowed".

Also, it's normally not necessary to close kernel messages with a period; 
most kernel messages do not have a closing period. Messages are not 
sentences and the periods only help increase the kernel size.

Thanks,
FJP

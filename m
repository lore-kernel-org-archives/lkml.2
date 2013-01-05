Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab3AEWSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 17:18:55 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:38727 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898Ab3AEWSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 17:18:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtsGAG6Zu08Y1OVO/2dsb2JhbABEgXuyFoEIghUBAQU4HgYcARALCw0JFg8JAwIBAgERFh4GDQEHAod7AQ0BC6dTiAIKGYELiHuQRAOIQoIWikOBD4RAiiGDBw
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="211474047"
Message-ID: <50E8A6D5.8020608@gmail.com>
Date: Sat, 05 Jan 2013 17:19:01 -0500
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/20100101 Firefox/18.0 SeaMonkey/2.15
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.8-rc[12] cpufreq build errors...
References: <50E8893E.8090502@lwfinger.net>
In-Reply-To: <50E8893E.8090502@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> Woody,
>
> There is a patch pending that fixes this problem. See
> http://lkml.indiana.edu/hypermail/linux/kernel/1212.3/01201.html. Note 
> that Rafael wrote "If you don't mind, I'll rename 
> CONFIG_CPU_FREQ_GOVERNOR to
> CONFIG_CPU_FREQ_GOV_COMMON when applying it, though". I think this 
> patch is working its way through the system, but I have not seem it in 
> mainline yet.
>
> Larry
Thanks, that fix does not work directly for me - cpufreq_governor.o is 
not even built now... But maybe I have missed something - had to do it 
"by hand"...

Rafael has confirmed that he will include a fix...

Thanks, Woody

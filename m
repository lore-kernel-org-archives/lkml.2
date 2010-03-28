Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0C1DEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 23:04:39 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:56099 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0C1DEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 23:04:38 -0400
X-Greylist: delayed 1044 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Mar 2010 23:04:38 EDT
Date: Sat, 27 Mar 2010 22:46:50 -0400
From: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100328024650.GA26522@jake.ruivo.org>
References: <20100323213338.GA29170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323213338.GA29170@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,
> +/* deprecated */
> +static int __init nosoftlockup_setup(char *str)
> +{
> +	no_watchdog = 1;
> +	return 1;
> +}
> +__setup("nosoftlockup", nosoftlockup_setup);
> +static int __init nonmi_watchdog_setup(char *str)
> +{
> +	no_watchdog = 1;
> +	return 1;
> +}
> +__setup("nonmi_watchdog", nonmi_watchdog_setup);
didn't you just add nonmi_watchdog parameter? I don't think there's a reason
to keep compatibility here.

the rest of the patch looks fine to me

-- 
Aristeu


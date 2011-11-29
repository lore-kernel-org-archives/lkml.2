Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1K2HEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:04:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:52825 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab1K2HET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:04:19 -0500
Message-ID: <1322550115.23348.72.camel@pasglop>
Subject: Re: [RFC PATCH v2 1/4] cpuidle: (powerpc) Add cpu_idle_wait() to
 allow switching of idle routines
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 29 Nov 2011 18:01:55 +1100
In-Reply-To: <4ED47EC2.2090802@linux.vnet.ibm.com>
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
	 <20111117112830.9191.1951.stgit@localhost6.localdomain6>
	 <1322434096.23348.6.camel@pasglop>	<4ED36A37.3030409@linux.vnet.ibm.com>
	 <1322512522.23348.43.camel@pasglop> <4ED47EC2.2090802@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 12:12 +0530, Deepthi Dharwar wrote:
> 
> Yes, this could be problematic as there is small window for the
> race condition to occur . Otherwise we need to manually schedule
> it by running a kernel thread but this would definitely have a
> overhead and would be an overkill. 

Depends what this "window" is. IE. What are you trying to protect
yourself against ? What's the risk ?

If it's just module unload, then stop_machine is probably your
friend :-)

Cheers,
Ben.



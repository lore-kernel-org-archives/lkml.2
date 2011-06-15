Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1FOCyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 22:54:06 -0400
Received: from support.opsdc.com ([65.254.219.9]:47005 "EHLO support.opsdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab1FOCyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 22:54:05 -0400
Subject: Re: Panic on OOM
From: Chris Fowler <cfowler@outpostsentinel.com>
Reply-To: cfowler@opsdc.com
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1106141947570.8257@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com>
	 <1308103443.2074.357.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141908100.7025@chino.kir.corp.google.com>
	 <1308105693.2074.361.camel@compaq-desktop>
	 <alpine.DEB.2.00.1106141947570.8257@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 22:53:51 -0400
Message-ID: <1308106431.2074.365.camel@compaq-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 19:51 -0700, David Rientjes wrote:
> So the issue is that the machine becomes unresponsive for an
> indefinite period of time between invoking your perl script and seeing
> the panic, or that the machine fails to reboot after "Rebooting in 10
> seconds..."? 

Both.  It still has not paniced.  I'm going to allow it to sit all night
and I'll see if it finally paniced in the morning.



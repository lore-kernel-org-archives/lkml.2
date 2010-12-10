Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0LJCpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:45:22 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:53244 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0LJCpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:45:21 -0500
Subject: Re: [PATCH] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1291901420.4063.24.camel@edumazet-laptop>
References: <1291863926.2965.1.camel@Dan>
	 <1291865039.2795.46.camel@edumazet-laptop>  <1291895472.2965.4.camel@Dan>
	 <1291898801.2965.6.camel@Dan>  <1291901420.4063.24.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 21:45:18 -0500
Message-ID: <1291949118.1877.2.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Well, it seems difficult to make a check here, its a generic function
> that happens to be used from different contexts.
> 
> Even using in_irq() might be a problem.

I agree it seems difficult - my only goal was to prevent subsequent
breakage with the capability check.  Does anyone have any suggestions
for a better approach here?

-Dan


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0CSSru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:47:50 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41809 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0CSSrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:47:49 -0400
Message-ID: <4BA3C64A.90409@kernel.org>
Date: Fri, 19 Mar 2010 11:45:30 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Jeremy Kerr <jk@ozlabs.org>
CC: users@linux.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] [KORG] Availability of SSL on kernel.org
References: <4BA2CFB7.7070108@kernel.org> <20100319035806.GB25308@linux-sh.org> <201003191600.13474.jk@ozlabs.org>
In-Reply-To: <201003191600.13474.jk@ozlabs.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (shards.monkeyblade.net [198.137.202.13]); Fri, 19 Mar 2010 11:45:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2010 01:00 AM, Jeremy Kerr wrote:
> Hi Paul,
> 
> Thanks for the report and testing - I've just committed a fix, plus a change 
> to reflect the https URL in the sample .pwclientrc file.
> 
> J.H.: If you update to the current git HEAD, the pwclient and .pwclientrc 
> files served by patchwork.kernel.org will now be more suitable for use with 
> https.

Ok should be fixed now, as I've updated patchwork.

- John 'Warthog9' Hawley

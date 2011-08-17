Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1HQNSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:18:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53094 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab1HQNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:18:05 -0400
Subject: Re: [PATCH 12/41] microblaze: Don't reimplement force_sigsegv()
From: Matt Fleming <matt@console-pimps.org>
To: monstr@monstr.eu
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4E4BBB8D.5020307@monstr.eu>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
	 <1313071035-12047-13-git-send-email-matt@console-pimps.org>
	 <20110816172010.GC29190@redhat.com> <20110816172049.GD29190@redhat.com>
	 <4E4BBB8D.5020307@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 14:17:57 +0100
Message-ID: <1313587077.2311.18.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-17 at 15:01 +0200, Michal Simek wrote:
> Oleg Nesterov wrote:
> > On 08/16, Oleg Nesterov wrote:
> >> This and the next patch seem to have the same problems with the
> >> changelogs as 18 and 19.
> >>
> >> 13-14 looks correct to me...
> > 
> > I meant 14-15, sorry for noise
> 
> Do you mean that there is
> From: Matt Fleming <matt.fleming@intel.com> ?
> 
> Anyway: I have looked at patches 12-15 and they look good to me.
> 
> Fix that "From:" line and you can add my

What's wrong with the From: line? That should be fine. Oleg was saying
that the description in the changelog needed updating.

> Acked-by: Michal Simek <monstr@monstr.eu>

Thanks.

-- 
Matt Fleming, Intel Open Source Technology Center


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0JNUCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:02:10 -0400
Received: from mail.digium.com ([216.207.245.2]:37810 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0JNUCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:02:09 -0400
Message-ID: <4CB76166.5050504@digium.com>
Date: Thu, 14 Oct 2010 15:00:38 -0500
From: Shaun Ruffell <sruffell@digium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Proper kernel irq time accounting -v4
References: <1286237003-12406-1-git-send-email-venki@google.com>	<4CB72BF3.4030601@digium.com> <AANLkTimSZDTjA-fsMzYb_5ogEYNkZArgWMJ5Q7LPbUb-@mail.gmail.com>
In-Reply-To: <AANLkTimSZDTjA-fsMzYb_5ogEYNkZArgWMJ5Q7LPbUb-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2010 01:19 PM, Venkatesh Pallipadi wrote:
> So, with this patchset you should see task CPU% showing only the exec
> runtime of the task and not si time. With the upcoming change the CPU
> times would get fixed as well. I am planning to send out the
> "exporting through /proc/stat patchset" as incremental change once
> this patchset gets into tip/next....

That is what I was looking for.  I didn't know if you were thinking
about using /proc/stat or some other mechanism.  I'll look forward to
seeing/testing that patch.

Thanks again,
Shaun


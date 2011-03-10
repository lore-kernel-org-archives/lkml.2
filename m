Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1CJVRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:17:49 -0500
Received: from mx2.compro.net ([12.186.155.4]:18367 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1CJVRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:17:48 -0500
X-IronPort-AV: E=Sophos;i="4.62,297,1297054800"; 
   d="scan'208";a="6392937"
Message-ID: <4D793FFA.8070807@compro.net>
Date: Thu, 10 Mar 2011 16:17:46 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel git bisect question
References: <4D793414.4090206@compro.net> <20110310211414.GA31719@merkur.ravnborg.org>
In-Reply-To: <20110310211414.GA31719@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 04:14 PM, Sam Ravnborg wrote:
> On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
>> Between git bisect [good | bad ]s should I always "make clean" or can I
>> count on the build system to take care of everything properly?
> 
> You can count on the build system to take care.
> It is very rare that the build system does not handle this.
> 
> Lately we fixed a bug where we did not properly handled when a file
> was renamed from *.S to *.c. But you will most likely not hit this.
> 
> 	Sam
> .
> 

Thanks

Mark

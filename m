Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2BKCs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 21:48:27 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:42099 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752283Ab2BKCs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 21:48:26 -0500
Message-ID: <4F35D6DD.8060301@xenotime.net>
Date: Fri, 10 Feb 2012 18:47:57 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Question: Documentation/dontdiff
References: <ADE657CA350FB648AAC2C43247A983F001F41F9DF813@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F41F9DF813@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 10:17 AM, H Hartley Sweeten wrote:
> Hello all,
> 
> Why is mach included in the dontdiff list?
> 
> This is causing all the arch/arm/mach-*/include/mach directories to be excluded
> when doing a diff with --exclude-from=Documentation/dontdiff.

Sorry, I don't know the answer to your question,
but feel free to send a patch to remove it from the dontdiff file.

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

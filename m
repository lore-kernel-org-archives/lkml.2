Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032744Ab2CSTwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:52:04 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:48989 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758203Ab2CSTwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:52:02 -0400
Message-ID: <4F678E61.9000606@xenotime.net>
Date: Mon, 19 Mar 2012 12:52:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question on kernel-docs comment syntax.
References: <4F677546.4070500@candelatech.com>
In-Reply-To: <4F677546.4070500@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 11:04 AM, Ben Greear wrote:

> I'd like to add some kdocs comment such that it creates a link
> to another struct (in another file/subsystem).
> 
>  * @get_et_stats:  Ethtool API to get a set of u64 stats.
>  *    See @ethtool_ops
> 
> The above does NOT appear to work as I would hope.
> 
> I've had no luck finding documentation for the syntax....
> anyone have a pointer to a proper web page or document?
> 
> Thanks,
> Ben

The only documentation for kernel-doc syntax that I know of
is in Documentation/kernel-doc-nano-HOWTO.txt .

'@' is used as a prefix for function parameters.
'&' is used as a prefix for structs.

Copying that file's text:

'funcname()' - function
'$ENVVAR' - environment variable
'&struct_name' - name of a structure (up to two words including 'struct')
'@parameter' - name of a parameter
'%CONST' - name of a constant.


HTH.
-- 
~Randy

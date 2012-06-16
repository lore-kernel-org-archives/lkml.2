Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab2FPTc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 15:32:57 -0400
Received: from tru75-7-88-161-131-83.fbx.proxad.net ([88.161.131.83]:47798
	"EHLO next.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756819Ab2FPTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 15:32:56 -0400
Message-ID: <4FDCDF59.9020208@free.fr>
Date: Sat, 16 Jun 2012 21:32:41 +0200
From: Wallak <wallak@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120604 Firefox/12.0 SeaMonkey/2.9.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, jweiner@redhat.com
Subject: Re: File copy is very slow on linux-3.4.2 (or linux-3.3x) on a specific
 hardware: AMD FX-8150 + 990FX (solved?)
References: <1108815600.134531433.1339443818361.JavaMail.root@zimbra44-e7.priv.proxad.net> <437497008.134549481.1339444456294.JavaMail.root@zimbra44-e7.priv.proxad.net> <20120612165357.GI6021@quack.suse.cz> <4FD78CE4.4000209@free.fr> <20120612210947.GB20007@quack.suse.cz> <4FD7C595.202@free.fr> <20120613065313.GA25425@quack.suse.cz> <4FD8F9F1.2000205@free.fr> <4FDA5048.5000107@redhat.com>
In-Reply-To: <4FDA5048.5000107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On 06/13/2012 04:37 PM, Wallak wrote:
>
>> HighTotal: 8052692 kB HighTotal: 8052692 kB
>> HighFree: 7978664 kB | HighFree: 6227412 kB
>> LowTotal: 229508 kB LowTotal: 229508 kB
>> LowFree: 195804 kB | LowFree: 148948 kB
>
> Did the BIOS remap essentially all of the low memory
> to end up above the 1GB boundary?

     May be not, but there was also a vmalloc= option on the linux 
command line; Theses options must be used with caution, and takes some 
low memory.
>
> This does not look like a system that should be run
> with a 32 bit kernel, since it only has 200MB of lowmem,
> giving you a 40:1 highmem:lowmem ratio, which is really
> too much to run well.
>
     You are right; I will try also in 64-bits mode.

                                                                         
                                         Wallak.


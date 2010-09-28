Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0I1RmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:42:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50844 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab0I1RmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:42:20 -0400
Message-ID: <4CA228CE.9000707@oracle.com>
Date: Tue, 28 Sep 2010 10:41:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH -next] sound/soc: fix printk format warning
References: <20100928141823.8c61000e.sfr@canb.auug.org.au> <20100928095846.9d4c7641.randy.dunlap@oracle.com> <20100928173303.GD10739@opensource.wolfsonmicro.com>
In-Reply-To: <20100928173303.GD10739@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/10 10:33, Mark Brown wrote:
> On Tue, Sep 28, 2010 at 09:58:46AM -0700, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
>> Fix dev_printk format warning:
> 
>> sound/soc/codecs/wm8985.c:731: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
> 
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Takashi already fixed that (and the change already seems to be in
> -next...).

I don't see the fix in linux-next 2010-0928.
Aha, he changed the variable type.  OK, thanks.

> When reporting type based warnings please always report the
> architecture you're building for, GCC seems to only generate the
> warnings if there's a difference in the underlying typedef which means
> that they don't always trigger on every architecture.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

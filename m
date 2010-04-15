Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0DOHyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:54:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:58148 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0DOHye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:54:34 -0400
Message-ID: <4BC6C635.5020107@suse.cz>
Date: Thu, 15 Apr 2010 09:54:29 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.7 Thunderbird/3.0.4
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 5/6] menuconfig: add support to show hidden options which
 have prompts
References: <4BC539DD.5040003@cn.fujitsu.com>	<4BC53A7A.5080502@cn.fujitsu.com> <20100414164839.e3c9391d.randy.dunlap@oracle.com> <4BC6C0CD.3020201@cn.fujitsu.com>
In-Reply-To: <4BC6C0CD.3020201@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.4.2010 09:31, Li Zefan wrote:
>>> +"o  To show hidden options, press <Z>.\n"
>>
>> maybe:
>>        To toggle the display of hidden options, press <Z>.
>> or     To alternate the ...
>> ?
>>
> 
> Sure, it does looks better. will include this change
> in a next patchset.

Please send an incremental patch if you want to change the help text, I
already merged your first version.

Michal

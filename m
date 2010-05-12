Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0ELGIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:08:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42187 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab0ELGIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=JjwWJOdhadKEW7SDh307g4aRH7tNqGZkLrRJVQ0FWgOj3pH30Kpybcb3oJK8ZINclQ
         tOdeCQur1nU2wx2dqqk2olHDQUYAgSVat7F8R4Z1svAraEHcRQyQkhTFpdNZSZOs5xpP
         UH0Lu0y08DxaOw8oOvQAgzu8ufgDizx5P4zQE=
Date: Wed, 12 May 2010 14:12:28 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Aristeu Rozanski <aris@redhat.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       davej@redhat.com, kyle@redhat.com, vgoyal@redhat.com,
       arjan@linux.intel.com
Subject: Re: [PATCH] kconfig: introduce nonint_oldconfig and
 loose_nonint_oldconfig (v3)
Message-ID: <20100512061228.GA5718@cr0.nay.redhat.com>
References: <20100413194747.GX31193@redhat.com>
 <20100413130031.d4dec19b.randy.dunlap@oracle.com>
 <20100413201759.GY31193@redhat.com>
 <4BC4D310.6060705@oracle.com>
 <20100413210352.GA31193@redhat.com>
 <4BC5C190.3020501@suse.cz>
 <20100506164834.GL20778@redhat.com>
 <20100507070257.GD5921@cr0.nay.redhat.com>
 <4BE4237A.8090701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BE4237A.8090701@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 07:28:10AM -0700, Randy Dunlap wrote:
>On 05/07/10 00:02, Américo Wang wrote:
>> On Thu, May 06, 2010 at 12:48:34PM -0400, Aristeu Rozanski wrote:
>>> This patch has been around for a long time in Fedora and Red Hat Enterprise
>>> Linux kernels and it may be useful for others. The nonint_oldconfig target
>>> will fail and print the unset config options while loose_nonint_oldconfig will
>>> simply let the config option unset. They're useful in distro kernel packages
>>> where the config files are built using a combination of smaller config files.
>>>
>>> Arjan van de Ven wrote the initial nonint_config and Roland McGrath added the
>>> loose_nonint_oldconfig.
>>>
>>> v2:
>>> - when -B and -b are used, return "2" so the reason can be distinguished from
>>>  other errors
>>> v3:
>>> - help updated
>>> - nonint_oldconfig won't update the config file if options are missing
>> 
>> The patch looks fine, but, why the name 'nonint_oldconfig'?
>> My English is not good enough to see what 'nonint' standards for...
>
>non-interactive
>

Got it, thanks!

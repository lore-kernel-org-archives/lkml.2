Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1BVTxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:53:48 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11899 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1BVTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:53:47 -0500
Message-ID: <4D641446.1080400@caviumnetworks.com>
Date: Tue, 22 Feb 2011 11:53:42 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging interfaces
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com> <1298398198-18482-2-git-send-email-kees.cook@canonical.com> <20110222181613.GU4000@outflux.net> <4D640133.9020901@caviumnetworks.com> <20110222184726.GV4000@outflux.net> <20110222191454.GB9991@suse.de> <20110222192532.GY4000@outflux.net> <20110222193418.773ccd4b@lxorguk.ukuu.org.uk> <20110222195018.GA4000@outflux.net>
In-Reply-To: <20110222195018.GA4000@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2011 19:53:42.0529 (UTC) FILETIME=[350A5F10:01CBD2CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 11:50 AM, Kees Cook wrote:
> On Tue, Feb 22, 2011 at 07:34:18PM +0000, Alan Cox wrote:
[...]
>
>> Or of course you could just chmod it 0700 in the distro !
>
> I'm trying to, but that involves a race condition since I can't control it
> during the mount (nor set the default mode like I was trying to with the
> patchset). tmpfs allows "mode=", but debugfs does not...
>

Someone skilled in the black arts of kernel programming might be able to 
add 'mode=' support to debugfs.

David Daney

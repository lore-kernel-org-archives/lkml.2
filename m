Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1HSONP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:13:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab1HSONN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:13:13 -0400
Message-ID: <4E4E6F76.8070508@suse.cz>
Date: Fri, 19 Aug 2011 16:13:10 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: jeffrey.t.kirsher@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace before
 signature tags
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>  <1313652390.32547.53.camel@Joe-Laptop>  <1313653632.2128.88.camel@jtkirshe-mobl> <1313654341.32547.62.camel@Joe-Laptop>
In-Reply-To: <1313654341.32547.62.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.8.2011 09:59, Joe Perches wrote:
>>>> From: Bruce Allan <bruce.w.allan@intel.com>
>>>> Unfortunately, now whenever patches are checked
>>>> by piping the output of 'git show' or 'stg show' through checkpatch it
>>>> warns not to use whitespace before all signature tags since these (and the
>>>> rest of the patch description) are indented.  Remove this test/warning.
...
> 
> I suppose checkpatch could have a different "--input=git"
> or some such to avoid certain things that git might produce
> that a patch would not.

One can also use 'git show --pretty=email', which does not do the
indentation.

Michal

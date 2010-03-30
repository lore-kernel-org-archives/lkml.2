Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab0C3Ooq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:44:46 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55689 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab0C3Ooo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=oOPRcQHtxqThySzsvC0m9PIbzyDNVxuIwewnb/os53M59b6hpBBXkPS43Xn+uAzhMs
         gEWiQXP2y15+tbLiLAo8nDX1rwXRpoAPXWS0n7voNRFj6u4GU1piuk1whbkjA8kswOks
         g0N1F1LmKrfDedo7uR/uhb/Zcf42SuQLsGWqc=
Date: Tue, 30 Mar 2010 17:44:33 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: David Airlie <airlied@linux.ie>, Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] drm: sysfs files error handling
Message-ID: <20100330144433.GM5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andi Kleen <ak@linux.intel.com>, David Airlie <airlied@linux.ie>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100328112438.GK5069@bicker> <4BAFC232.8010404@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAFC232.8010404@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 10:55:14PM +0200, Andi Kleen wrote:
> , Dan Carpenter wrote:
>>
>> In the original code we used "j" as an iterator but we used "i" as an
>> index.
>>
>> -               for (j = 0; j<  i; j++)
>> -                       device_remove_file(&connector->kdev,
>> -&connector_attrs[i]);
>
> I guess this really should be a attribute group anyways?
>
> Typically when there's such a open coded loop it means the wrong
> interfaces are being used.

My graphics card is crap and doesn't use this code at all.  I'd feel 
uncomfortable those changes without being able to test it.

So while, you are probably right, someone else should probably do that.

regards,
dan carpenter

> -Andi

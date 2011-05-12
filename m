Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1ELJDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:03:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48239 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1ELJDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LYk5iQka4kUHvK34Rohw7QkpqyhueNlqJZtfhKkACGqTgiKmIJ81sZBLaXrN3FtlU/
         Een3R0Ta/YMcs1/4f9JXZKlDo/1jNa+28yxYQVk95YeFkz47JkZYkof44PBIW68rblWD
         HpJ/H8TZXWyrT9wVs7FQRWPDabXleCIJ+lVOo=
Subject: Re: [patch v2 0/5] percpu_counter: bug fix and enhancement
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305190936.3795.1.camel@edumazet-laptop>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 11:03:34 +0200
Message-ID: <1305191014.3795.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 12 mai 2011 à 11:02 +0200, Eric Dumazet a écrit :
> Le jeudi 12 mai 2011 à 10:59 +0200, Tejun Heo a écrit :
> > Hello,
> > 
> > On Thu, May 12, 2011 at 04:55:20PM +0800, Shaohua Li wrote:
> > > sure, but it's quite difficult to determine a @maxfuzzy in his proposal
> > > I thought (and could confuse user), did I miss anything?
> > 
> > I don't think @maxfuzzy is necessary there.  I wrote this before but
> > why can't we track the actual deviation instead of the number of
> > deviation events?
> > 
> 
> Thats roughly same thing (BATCH multiplicator factor apart)
> 
> Most percpu_counter users for a given percpu_counter object use a given
> BATCH, dont they ?
> 
> 


I guess nr_cpu_ids would be a nice @maxfuzzy default value...




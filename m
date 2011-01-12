Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab1ALJwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:52:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59338 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1ALJwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZiNuEs5BYNAkvA/d4C3zCYC1BZwzsFJh0iANVfixpIY8yVlba6jWiNKtaNyJEo+UhI
         XkhwYrYBvOFE4k1nlxDytG1F2ck4aeKzDKWvnm9GN4O27PGZ5lcTwJIBTzxobMbT8BCM
         nxMsgWGj4rzLRUQnlWKBu5Uct9/fy8omYqC74=
Date: Wed, 12 Jan 2011 10:52:31 +0100
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>, Minchan Kim <minchan.kim@gmail.com>,
        Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: WARNING: at kernel/workqueue.c [was: mmotm 2011-01-06-15-41
 uploaded]
Message-ID: <20110112095231.GA7734@mtj.dyndns.org>
References: <201101070014.p070Egpo023959@imap1.linux-foundation.org>
 <4D2ADD43.2020702@gmail.com>
 <AANLkTin7h=R0cfzpeuvpTAGRFCsFocJezpW7Riz5Za4z@mail.gmail.com>
 <AANLkTimeUN9m-roDmsfaMaiD4wZw1wETYsf+dONjpmyj@mail.gmail.com>
 <20110111143244.GC30607@htj.dyndns.org>
 <AANLkTinX5R7-CzrLW=b4PwC3v3QucQkgz7Vs6tnYG7Hr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinX5R7-CzrLW=b4PwC3v3QucQkgz7Vs6tnYG7Hr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 12, 2011 at 09:34:38AM +0800, Hillf Danton wrote:
> It looks that WORKER_NOT_RUNNING could be defined finer :/

It's an enum definition.  How does wrapping it inside () make it any
finer?

-- 
tejun

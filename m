Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1CEKlD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:41:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44763 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1CEKlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZUMUHdzMGft4sLRDyLCVKmj785vBMBhgzjtHoM1dTqx7QfPwNL5vf+r80TCwoCIIrq
         dL1oZgo/oAhLF00xgTPV2rvxN4Ut2IXM55vLMu9T9fl6ukWWGARTqOnJfb4vfIq0EzP0
         5k1M8HLePToIZvavAnju/d6HHxcxLxB0aRVls=
Date: Sat, 5 Mar 2011 11:40:49 +0100
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Subject: Re: [PATCHSET] block: convert block drivers to ->check_events()
Message-ID: <20110305104049.GF20499@htj.dyndns.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
 <20110125130638.GS27510@htj.dyndns.org>
 <20110201103143.GF14211@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201103143.GF14211@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:31:43AM +0100, Tejun Heo wrote:
> This will now create some minor conflicts on top of the mainline.
> Please let me know when you're ready to apply this.  I'll refresh and
> repost.

Ping?

-- 
tejun

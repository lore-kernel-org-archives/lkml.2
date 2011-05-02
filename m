Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1EBPJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:09:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63480 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1EBPJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m8oQFvCSIUHPF/WzTCJGecJ+9b6jCzE3qp467wI6HITfcIvGbCZUsjuMhrAatSqCxX
         vO7XJDghIguYWIxD/GEoGePD/BjOofXr2xkISIetokHnhVIpdaSRzubbMSkHU5yzYrg9
         tIE0BDkJDcsbhlwwPoIVY7xa9EefseH7HWyDs=
Date: Mon, 2 May 2011 17:09:45 +0200
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL tip:x86/mm] Unify 32 and 64bit NUMA init paths
Message-ID: <20110502150945.GE22117@htj.dyndns.org>
References: <20110502091334.GB22117@htj.dyndns.org>
 <20110502101828.GB27072@elte.hu>
 <20110502122319.GC22117@htj.dyndns.org>
 <20110502150401.GA21680@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502150401.GA21680@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:04:01PM +0200, Ingo Molnar wrote:
> Doesnt build on 32-bit allyesconfig:
> 
>   ERROR: "physnode_map" [drivers/net/wan/dscc4.ko] undefined!
>   ERROR: "physnode_map" [crypto/tcrypt.ko] undefined!

Dang, I only checked allmodconfig.  Testing allyesconfig now.

Thanks.

-- 
tejun

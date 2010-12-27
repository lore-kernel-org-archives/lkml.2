Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab0L0MPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 07:15:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43714 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab0L0MPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 07:15:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xVApancoIIcAnHHeIYsvpvHcuvJg9Kkv3L+ZLuJnda+1wtkYDwCpLbvTyVnhF14waU
         TYVs4FzLCMhYgsptqpa3zsqcP5kYVNsMv/UyMu5DxGGWzGFep/kFjeStKIjimX1LTRHR
         5EwnciSRn+paPN8Xpl/X9Lf7uPVAAz//nleoM=
Date: Mon, 27 Dec 2010 13:14:54 +0100
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
Message-ID: <20101227121454.GB488@htj.dyndns.org>
References: <4D073FA9.9020801@gmail.com>
 <1292378268.2323.464.camel@sli10-conroe>
 <4D08CBF4.6040102@gmail.com>
 <1292460817.2323.465.camel@sli10-conroe>
 <20101216054620.GA3241@merkur.ravnborg.org>
 <1292479000.2323.468.camel@sli10-conroe>
 <4D09E0EE.7040605@gmail.com>
 <1292808518.10593.8.camel@sli10-conroe>
 <4D0F7C5A.1060107@gmail.com>
 <1293071914.10593.10.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293071914.10593.10.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 10:38:34AM +0800, Shaohua Li wrote:
> The first patch in the series isn't related to this issue, please
> consider merge it.

Can you please re-post it?  Thanks.

-- 
tejun

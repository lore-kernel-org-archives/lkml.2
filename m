Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1BAKf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:35:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34119 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1BAKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:35:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vj67o3Ac7mm0qEpGVP4olqqpPrTFkHjVoALne0G44qTd+srS+mqlFo6HtOxYx8OYhK
         wzWqXJeFvdxcWuuw3ZoxfdoOv0qG7LAjQ3YQUkfgg75BkCymVeqbMYtT+gjnEMo/aO+N
         r4uQQBHk7dyfU0N0J/1KYJ41czolFZNrq0VoI=
Date: Tue, 1 Feb 2011 11:35:19 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110201103519.GG14211@htj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
 <20110118021417.D347A1807B7@magilla.sf.frob.com>
 <20110127154600.GE24925@htj.dyndns.org>
 <20110127174857.GG24925@htj.dyndns.org>
 <20110128204030.52D31183C1E@magilla.sf.frob.com>
 <20110131154117.GK7459@htj.dyndns.org>
 <20110131155411.GA1613@redhat.com>
 <20110131160724.GO7459@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131160724.GO7459@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 31, 2011 at 05:07:24PM +0100, Tejun Heo wrote:
> I thought it was the first one but might be mistaken.  I left it
> running for a couple of minutes several times but maybe it just needs
> more time.  I'll try again.

So, it turned out my computer was too slow and/or I was too impatient.
make xcheck behaved the same before and after the patchset.  All six
passed with one skipped.

Thanks.

-- 
tejun

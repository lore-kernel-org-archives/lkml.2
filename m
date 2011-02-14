Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1BNQYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:24:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37501 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab1BNQYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BeimDLgjZRaPFa/1PumKNrd0EDrzxxZGMTgNr8dVGoCqWRcfeuZfSrdixvhSOovoC3
         IUOweg1ghl3m2zgnFvEYg5heAxjAC79oBsOY2htZ/am/QMPQYZrAguNfpsat2USkgDK5
         m6ZJmw7SA6I5vBfRIqr5xMFwvA8R9fehzHCBA=
Date: Mon, 14 Feb 2011 17:24:37 +0100
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] dlm fix for 2.6.38
Message-ID: <20110214162437.GY18742@htj.dyndns.org>
References: <20110211233844.GC30276@redhat.com>
 <1297525475.2584.1.camel@dolmen>
 <20110212155100.GR3770@htj.dyndns.org>
 <20110214153844.GA6909@redhat.com>
 <20110214154601.GS18742@htj.dyndns.org>
 <20110214162115.GB6909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214162115.GB6909@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:21:15AM -0500, David Teigland wrote:
> > Hmmm... okay.  At any rate, please use alloc[_ordered]_workqueue()
> > interface.  create[_singlethread]_workqueue() will be deprecated soon.
> 
> Oh, I'll switch to the other API in the patch set for the next merge.
> Dave

Alright.  Sounds good.  Thanks.

-- 
tejun

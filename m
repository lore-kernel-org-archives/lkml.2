Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab1FABMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:12:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62960 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab1FABMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jxL76MUlLi/rl3CArdjPRJRXPloP7tMdBAPQQmkd2F+QaGx3TqxF3PreODvAEj1xrn
         0eX7dCg9mne21wRYGUBJ9HSLSVFCJbRmd7UxUkDLXtVLfsAAcD5lD7gQvr9KQz/sWhYN
         9vQkfMETNcWyyLPXBthjnZKQYCby+8ULDEd9M=
Date: Wed, 1 Jun 2011 10:12:15 +0900
From: Tejun Heo <tj@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: clean up time (pass 1)
Message-ID: <20110601011215.GA16661@mtj.dyndns.org>
References: <20110601110616.861247de.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601110616.861247de.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stephen.

On Wed, Jun 01, 2011 at 11:06:16AM +1000, Stephen Rothwell wrote:
> slabh

This definitely is a dead branch.  It was a temporary testing branch
preparing for wide-scale update and the whole thing has been in
mainline for a very long time now.  Sorry about not updating it
earlier.

Thank you.

-- 
tejun

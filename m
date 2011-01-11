Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1AKR4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:56:30 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34446 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1AKR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:56:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZJagVhDLmr4fbP0QFeHig49fapZqY8pNkIW+iUNJvxayvsj8SaefyWjZdB3kcuqDha
         qaiNznAA2gShRFCKnNUy/CcIeV9eQWJIecKx93beWHwJmb9cO2ZEzURgjOG+bU1DTLAu
         Dx+Lyq83sZbvX8tdWV+TANXpzeZDrFfCsBmKI=
Date: Tue, 11 Jan 2011 18:56:21 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86,percpu: Move out of place 64 bit ops into X86_64 section
Message-ID: <20110111175621.GE15933@htj.dyndns.org>
References: <alpine.DEB.2.00.1101101034290.12243@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101101034290.12243@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:35:23AM -0600, Christoph Lameter wrote:
> 
> Subject: x86,percpu: Move out of place 64 bit ops into X86_64 section
> 
> Some operations that operate on 64 bit operands are defined for 32 bit.
> Move them into the correct section.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu#fixes-2.6.38.  Thank you.

-- 
tejun

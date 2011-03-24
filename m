Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1CXPRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:17:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38821 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab1CXPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FmRabKjz/ZUUKI05Z3vWtoqzYYXKHZgfMpMTE2PsNdRYrdVJuIF05yfNJqwJmvVPkX
         wT2Cd+dvn6LzlyuvrjZiPg6HKH/1sLdamn31vWOUydxzTCX5whY9zv1lnw2fkU1RzdDw
         14t/tEDfsVYcSRmsqPyjG6Yni7D62nITJ67nk=
Date: Thu, 24 Mar 2011 16:17:19 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] powerpc: add clock_adjtime for powerpc
Message-ID: <20110324151719.GA6738@riccoc20.at.omicron.at>
References: <20110324150517.GA6710@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110324150517.GA6710@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 04:05:17PM +0100, Richard Cochran wrote:
> This patch adds the clock_adjtime system call to the powerpc architecture.

Never mind this patch.

Stephen Rothwell already posted a patch on linuxppc-dev adding this
syscall eariler today.

Thanks,
Richard

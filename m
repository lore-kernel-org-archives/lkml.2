Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0HIOSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:18:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53740 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab0HIOSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lEiid6MkP1/m5iAO7bk1+bqKzrBBG+MiEPpDAKyKpdYCYbzg9t9dNv5fawAGxYnmOf
         pibEPzV0Fov1pk6mrgEYAfNkn74fuYQ4t6CdCFHkPGxCPkF/3iJrvWPNLB1hKf7g1yk5
         c0VwGt/ouFvUHfioiFqtRl2alUjNvNC/CY6Jw=
Date: Mon, 9 Aug 2010 16:19:06 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: viresh kumar <viresh.kumar@st.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Query: Patches break with Microsoft exchange server.
Message-ID: <20100809141906.GA31487@riccoc20.at.omicron.at>
References: <4C5F9B25.8080401@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5F9B25.8080401@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:37:33AM +0530, viresh kumar wrote:
> 
> Has anybody found a solution to this kind of issues? Are there any
> workarounds possible?

I have this same problem. The exchange server rewrites incoming and
outgoing plain text emails as it sees fit, and our IT department seems
unable to turn this "feature" off.

One work around is to get an gmail account and use IMAP.

Good luck,
Richard

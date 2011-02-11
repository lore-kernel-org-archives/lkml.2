Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1BKG6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 01:58:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45911 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1BKG6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 01:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yAWMVftKnavw4eF84CGn4AzbpEqrPdnwyNdDkTIzDLhwivh/eDA/OvE+G9nR/oBDHr
         q2NVi6bpwxY/DXjaSXuScBvR0JamC6QYkt9NYi818aKTXyXq+Q/xbryK3M6XllTKp9jR
         QKrmmyjfkQnXHWSCSx+ivT1wXepecHjCUC2A8=
Date: Fri, 11 Feb 2011 07:58:05 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: netfilter is not a filesystem
Message-ID: <20110211065805.GB2914@riccoc20.at.omicron.at>
References: <bug-28862-10286@https.bugzilla.kernel.org/>
 <20110210141119.56d789fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210141119.56d789fc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 02:11:19PM -0800, Andrew Morton wrote:
> On Thu, 10 Feb 2011 21:55:26 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=28862
> > 
> >            Summary: /proc/net/ip_conntrack: no space left on device
> >                     systematically
> 
> This is why I'm forever nagging people to not just grab some errno
> because its name happens to sound similar to the error you just detected.

Today my brain has thrown an -EMIXEDMESSAGES:

   https://lkml.org/lkml/2011/2/10/172

Sorry, couldn't resist,

Richard

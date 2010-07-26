Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab0GZQwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:52:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36262 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab0GZQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PC2CXqqQuIs2yjKSfPJ9uR7eJrHF98N1H7EpNEceZTqe6hScDT5Cbi5WLRYUqBjvSr
         EeLjmue961D1Ed8zPbM2csk7+qQ0s5djryyqGydv21rd0p70p9o4l4916xcWuWSUw37X
         rUOfNMK24urerDPPiJ4NIoasxGnLM+LwibXnY=
Date: Mon, 26 Jul 2010 20:52:35 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: check capabilities in open()
Message-ID: <20100726165235.GA3485@albatros>
References: <20100724160701.GA4907@albatros>
 <20100724182355.GA9134@ZenIV.linux.org.uk>
 <20100725054511.GB9018@albatros>
 <20100726112317.GB9185@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726112317.GB9185@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 07:23 -0400, Ted Ts'o wrote:
> The reason why the apm device needed to sample the suser() bit is that
> it can be opened by root and non-root processes, but it wanted to
> extend the Unix/Linux paradigm that privileges are tested at open()
> time.
Yes, it's exactly that I mean, check at open() time and grand high or
less priviledges.

> 
> So this is a not a bug, but quite deliberately, by design.
If it is explicitly designed to check UID at open() time and to have 2
kinds of file descriptors - priviledged and nonpriviledged, I'm fine
with this.

I wanted kernel community to draw attention because this moment was
not obviously for me and I thought it was a design flaw. Now I'm pleased
with your explanation, thank you.

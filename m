Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823Ab2CVQzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:55:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39967 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2CVQzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:55:20 -0400
Message-ID: <4F6B5902.1080607@zytor.com>
Date: Thu, 22 Mar 2012 09:53:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com> <4F6B51C9.6010904@suse.cz>
In-Reply-To: <4F6B51C9.6010904@suse.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 09:22 AM, Jiri Slaby wrote:
> 
> That explanation is not fully correct. C99 explicitly says (6.7.5.3.14):
> An identifier list declares only the identifiers of the parameters of
> the function. An empty list in a function declarator that is part of a
> definition of that function specifies that the function has no
> parameters. The empty list in a function declarator that is not part of
> a definition of that function specifies that no information about the
> number or types of the parameters is supplied.
> 
> So what you are trying to force here holds only for (forward)
> declarations. Not for functions with definitions (bodies). Is checkpatch
> capable to differ between those?
> 

We shouldn't use it anyway.  gcc might take it that way in C99 mode, but
it's unclear if it does it in the default mode, and having declarators
and definitions be different is just asking for trouble.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2EVWl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:41:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62703 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab2EVWld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:41:33 -0400
Date: Tue, 22 May 2012 15:41:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: James Borum <james.borum@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: v3.4 will not compile
In-Reply-To: <1337682220.2932.7.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.00.1205221541070.18325@chino.kir.corp.google.com>
References: <CAGFGw3m_aTYv7hGYVQAajoQJ5nD7jE8iO9VdjFtQZcA72kKPew@mail.gmail.com> <alpine.DEB.2.00.1205212038100.13522@chino.kir.corp.google.com> <1337682220.2932.7.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, James Bottomley wrote:

> No, that's not it.  The problem is that DLM can't be a module if GFS_FS
> is built in because GFS needs to use DLM functions (so DLM can be a
> module as long GFS_FS is)
> 
> so this should be
> 
> && (DLM=y || (DLM=m && GFS_FS=m))
> 

Sounds good for s/GFS_FS/GFS2_FS/

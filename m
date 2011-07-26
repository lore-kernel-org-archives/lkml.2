Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1GZUaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 16:30:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1GZU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 16:29:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110726132249.69533206.rdunlap@xenotime.net>
References: <20110726132249.69533206.rdunlap@xenotime.net> <1311706717-7398-1-git-send-email-serge@hallyn.com> <1311706717-7398-2-git-send-email-serge@hallyn.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: dhowells@redhat.com, Serge Hallyn <serge@hallyn.com>,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        akpm@osdl.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 01/14] add Documentation/namespaces/user_namespace.txt
Date: Tue, 26 Jul 2011 21:29:46 +0100
Message-ID: <27437.1311712186@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> wrote:

> > +Any task in or resource belonging to the initial user namespace will, to this
> > +new task, appear to belong to UID and GID -1 - which is usually known as
> 
> that extra hyphen is confusing.  how about:
> 
>                               to UID and GID -1, which is

'which are'.

David

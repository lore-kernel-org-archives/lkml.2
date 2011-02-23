Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1BWRAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:00:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932124Ab1BWRAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:00:08 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110217150306.GB26395@mail.hallyn.com>
References: <20110217150306.GB26395@mail.hallyn.com> <20110217150224.GA26334@mail.hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: dhowells@redhat.com, LSM <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>, James Morris <jmorris@namei.org>,
        Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com
Subject: Re: [PATCH 2/9] security: Make capabilities relative to the user namespace.
Date: Wed, 23 Feb 2011 16:59:19 +0000
Message-ID: <2761.1298480359@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serge@hallyn.com> wrote:

> +		/* If you have the capability in a parent user ns you have it
> +		 * in the over all children user namespaces as well, so see
> +		 * if this process has the capability in the parent user
> +		 * namespace.
> +		 */

"... in the over all children user namespaces ..." I think need a couple of
words dropping.

David

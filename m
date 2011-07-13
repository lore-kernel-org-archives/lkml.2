Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1GMQEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:04:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab1GMQEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:04:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1310513452-13397-4-git-send-email-serge@hallyn.com>
References: <1310513452-13397-4-git-send-email-serge@hallyn.com> <1310513452-13397-1-git-send-email-serge@hallyn.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [RFC PATCH 03/14] keyctl: check capabilities against key's user_ns
Date: Wed, 13 Jul 2011 17:04:11 +0100
Message-ID: <3112.1310573051@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge@hallyn.com> wrote:

> From: Serge E. Hallyn <serge.hallyn@canonical.com>
> 
> ATM, task should only be able to get his own user_ns's keys
> anyway, so nsown_capable should also work, but there is no
> advantage to doing that, while using key's user_ns is clearer.
> 
> changelog: jun 6:
> 	compile fix: keyctl.c (key_user, not key has user_ns)
> 
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: David Howells <dhowells@redhat.com>

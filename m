Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab2CGVsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:48:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2CGVsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:48:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 04/29] Disintegrate asm/system.h on all arches
Date: Wed, 7 Mar 2012 21:47:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk> <20120307194641.15987.33637.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194641.15987.33637.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203072147.42218.arnd@arndb.de>
X-Provags-ID: V02:K0:czw8/lXwKqYkKEVyWNtyr6/ymsVYRfy3K7M4Qk63VbG
 Ey3kPKOo5mZFZEuCuhbcXbFn6H8XRRjSyJz1kbGoI39LlJue85
 /wktH4Nq8DWW83nrg1NnnET+/zFy0zshNSikKcqBB0vAILHi4U
 vioINurDZRaXAvBqTGugZM9PQONxJJskhKHOURxR6FXdsRMncG
 HpLBJGZRlyI09Aq+iNp7UwfPfOimc3iD3/MbvzgJiyvmymP/SP
 iXHrzNznLxS3A25bdM0BotN7Af/n9OJwkPZ+tN8Wtr0UYEWej8
 vF3kybrxkNbIwUTiUhOF4X9e1ub581rV+hY31P8lIJmf5aj0rm
 Aw5cByNkMjdsmvbIFmW4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2012, David Howells wrote:
> asm/system.h is a cause of circular dependency problems because it contains
> commonly used primitive stuff like barrier definitions and uncommonly used
> stuff like switch_to() that might require MMU definitions.

In this patch, you seem to have put the wrong description, as this the alpha
specific part of your series but the description is the same as in patch 3.

	Arnd

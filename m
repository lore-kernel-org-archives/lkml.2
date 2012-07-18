Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2GRUqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 16:46:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37913 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2GRUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 16:45:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1207161158290.22772@tundra.namei.org>
References: <alpine.LRH.2.02.1207161158290.22772@tundra.namei.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jul 2012 13:45:31 -0700
X-Google-Sender-Auth: JJ3tLkL9Q7SO0g_pN8Shrp6soFo
Message-ID: <CA+55aFxEw40XvV9wTS3vTVZynSHSvwwg3ywd-+m=xgbZGyVfhQ@mail.gmail.com>
Subject: Re: [GIT] Fix SELinux regression
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 6:59 PM, James Morris <jmorris@namei.org> wrote:
> Now with the correct patches and signoffs.

Ok. I changed the SELinux capability name string to match the renamed
capability (it's CAP_BLOCK_SUSPEND these days, not CAP_EPOLLWAKEUP).

Please double-check.

             Linus

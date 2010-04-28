Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0D1SmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:42:17 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:50596 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab0D1SmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=nK7lEIEhM5DZUvYqb+JSXXSpf3maXzAMAVwBJ6m0wclaAU/c3tWShzxTcvxiUkhTPB
         DA70ITUM0kSchKgbxpXyM/sLRd0dHC/P8yJNxGeH8M1G0E8iVfDhZpKS73y4TyOgT+bU
         UEuZitgv76oF6mvX6pQzGJrNN7ID4lesbXnRY=
From: Harald Arnesen <harald@skogtun.org>
To: Tejun Heo <tj@kernel.org>
Cc: trivial@kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@au1.ibm.com>
Subject: Re: [PATCH] trivial: use (C) instead of \251
References: <4BD80037.9060704@kernel.org>
Date: Wed, 28 Apr 2010 20:42:09 +0200
In-Reply-To: <4BD80037.9060704@kernel.org> (Tejun Heo's message of "Wed, 28
	Apr 2010 11:30:31 +0200")
Message-ID: <87r5lzpgfy.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> The latin-1 copyright character \251 is invalid in ASCII or UTF-8 and
> causes annoying problems with some editors and tools.  Use (C)
> instead.

Why do we need anything there at all?
-- 
Hilsen Harald.

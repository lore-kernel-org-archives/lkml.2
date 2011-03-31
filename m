Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137Ab1CaTzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:55:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44720 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759254Ab1CaTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=ZCL8I+lF+32chS31fqozr7MU4YYV+iq4xm7JhhSziCHUtcmeq/S98Or3hyPXP5OOko
         7Cyvlj0u9WTFmDVzfG6Mj+78c9U4cCPkgfzDM+ShH4TO7uoyRuudh4pUI4i17xX5T1qu
         ceWTw+GDqeqp8Oqt+z9E9mKyx/tk2l6HQNjFg=
MIME-Version: 1.0
In-Reply-To: <1301601122-25431-2-git-send-email-vapier@gentoo.org>
References: <1301601122-25431-1-git-send-email-vapier@gentoo.org> <1301601122-25431-2-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 31 Mar 2011 15:55:03 -0400
X-Google-Sender-Auth: 4CVfcKDMHMmvs_EcPM4WrD4OH-0
Message-ID: <AANLkTikkaNDYC6bbihTTa4+LjXeUJkTKqBj1W65=fnqm@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 2/2] Blackfin: use new common
 PERCPU_INPUT define
To: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 15:52, Mike Frysinger wrote:
> The Blackfin percpu input sections are outdated, so rather than update
> them, drop them completely and use the new common define.

Tejun: btw, i'm not expecting you to merge this one.  it's just an
example of why we need this common code change.  once the
vmlinux.lds.h patch is merged, i can run this through my tree like
normal.
-mike

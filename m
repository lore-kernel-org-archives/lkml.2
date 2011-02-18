Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab1BRWRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:17:06 -0500
Received: from smtp-out.google.com ([74.125.121.67]:17412 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1BRWRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:17:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GCefZk+H1T+5JgkrvyEZbAQuQwcQIdOB0kC9J56DRmXKV5np5WdZspoBM+W4OCqZtA
         04JGZH34trtThxUeIBIA==
MIME-Version: 1.0
In-Reply-To: <20110218214857.GK26654@redhat.com>
References: <20110214164139.GC13097@redhat.com>
	<20110214180111.18776.57533.stgit@neat.mtv.corp.google.com>
	<20110218214857.GK26654@redhat.com>
Date: Fri, 18 Feb 2011 14:16:59 -0800
Message-ID: <AANLkTi=wM_0cwYDSDcWzA==ZrYxRhumSBw3h-pU-On0Q@mail.gmail.com>
Subject: Re: [PATCH v3] Avoid preferential treatment of groups that aren't backlogged
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 1:48 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Chad,
>
> Got following compile warning with this patch.
>
>  CC      block/cfq-iosched.o
> block/cfq-iosched.c: In function ‘cfq_group_service_tree_add’:
> block/cfq-iosched.c:874: warning: unused variable ‘n’
> block/cfq-iosched.c:873: warning: unused variable ‘__cfqg’
>
> Lets get rid of some unused variables. May be generate a V4 of the patch.

Good catch, thanks Vivek.  I'll send a new patch.

Chad

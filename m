Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab1ANJdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:33:46 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41125 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab1ANJdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:33:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cnLTuflRKjDIzH2sP4r7o2tDTQMglVlm6VODyGjKuddX4GOfnDkRrpmJfSTzH8MbVK
         XkJwjKa13bBIiqZxhNVb9p3CHO1l9+eFkSHpWnmO/JWB1oxee+Rhtm5lriRCEuji6i/Y
         +vB5iVRsb7AN9hNVF3Bzqq1Xs88NrzcAvCAb4=
Date: Fri, 14 Jan 2011 17:33:19 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jianbin Kang <kjbmail@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] kbuild: add global tags generation.
Message-ID: <20110114093319.GA10219@cr0.nay.redhat.com>
References: <AANLkTimsPj4seDW9ffDQ+uydZcRk_T6BsP7x0dr0Qi++@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimsPj4seDW9ffDQ+uydZcRk_T6BsP7x0dr0Qi++@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 03:13:01PM +0800, Jianbin Kang wrote:
>gnu global (http://www.gnu.org/software/global/) is a source code tagging system
>It is really cheap to support it in kbuild system.
>

Looks pretty good,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

But... 1) you missed your Signed-off-by; 2) you should Cc linux-kbuild
rather than trivial.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1ANJn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:43:56 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61833 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1ANJnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:43:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LncB2Rda+VEcVPMWNGQiveJhyplqervg1N0Q2v/9rS6guiINpEVcPWEFhDfNte1HAW
         vwxEZmjAXN5CEbYHKFQett5lQXRo//Nb19E2xVoW2JkWpXIg8wK7vAwmNErxnnVUHvMK
         ayLLzSlhZs3tK9fl/u+EWD1wHzzXwQtajuD1I=
MIME-Version: 1.0
In-Reply-To: <20110114093319.GA10219@cr0.nay.redhat.com>
References: <AANLkTimsPj4seDW9ffDQ+uydZcRk_T6BsP7x0dr0Qi++@mail.gmail.com>
	<20110114093319.GA10219@cr0.nay.redhat.com>
Date: Fri, 14 Jan 2011 17:43:51 +0800
Message-ID: <AANLkTinp4x7i+771CQdCJQmEJthBjow3ZR305ie-iYHb@mail.gmail.com>
Subject: Re: [PATCH] kbuild: add global tags generation.
From: Jianbin Kang <kjbmail@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/14 Américo Wang <xiyou.wangcong@gmail.com>:
> On Fri, Jan 14, 2011 at 03:13:01PM +0800, Jianbin Kang wrote:
>>gnu global (http://www.gnu.org/software/global/) is a source code tagging system
>>It is really cheap to support it in kbuild system.
>>
>
> Looks pretty good,
>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> But... 1) you missed your Signed-off-by; 2) you should Cc linux-kbuild
> rather than trivial.
er, where should signed-off-by be put? At the bottom of the mail or
the bottom of the patch?

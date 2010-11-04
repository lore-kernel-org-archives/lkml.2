Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0KDWcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:32:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40295 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0KDWcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SI14YTHWKzmtcIsujVVi+c4W2R1d+zB7RhL2G9nKfSLmwl2rRgOXks5Jgf+JXgRmjU
         Yq5ImoOLlcuY5Gr/inLYtUPD0z4z67uvv/tYXcBZAhIA0qp8oJ+sz1SrRbY83LnzetYG
         RbGrRWftyPxMx9KmfBYorLxE0eY3fLN179vqc=
MIME-Version: 1.0
In-Reply-To: <1288280550-26997-1-git-send-email-richard@nod.at>
References: <1288280550-26997-1-git-send-email-richard@nod.at>
Date: Thu, 4 Nov 2010 22:32:18 +0000
Message-ID: <AANLkTikp3-n_X9Au9+teixoMs3JEmj0XMShB-hacSZXj@mail.gmail.com>
Subject: Re: [PATCH] um: fix ptrace build error
From: Will Newton <will.newton@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, namhyung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 4:42 PM, Richard Weinberger <richard@nod.at> wrote:
> Both 0a3d763 and 9b05a69 broke the um build.
> This patch fixes the issues.
>
> 0a3d763 introduced the undeclared variable "datavp".
> The patch seems completely untested. :-(
>
> 9b05a69 changed arch_ptrace()'s signature but did not
> update um/include/asm/ptrace-generic.h.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Tested-by: Will Newton <will.newton@gmail.com>

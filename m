Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab1DRPCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:02:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46053 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab1DRPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:02:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QrrhaEOcOzjdOu4naC6O+Qa+tuouXIt/eoRIFolzwllLXa459Z14CsKXZWG4Ey34Ea
         UV/oatKwR1ClA/CZ+uGMmFjOPtY1JiO7FYKhAMJhccQi4jx02abmRBnwt2+l7hjLmM79
         cJds9IZ1eS21M4xvYPHkFgTFhrsTODJmeqh0k=
MIME-Version: 1.0
In-Reply-To: <20110418082838.GA30088@hallyn.com>
References: <BANLkTikTxCFHs2xb4b5QFQp3SJAEjgyRJg@mail.gmail.com>
	<20110417180722.GA21112@hallyn.com>
	<BANLkTinumLPEsstxP9px9=K23SUR9e2aRw@mail.gmail.com>
	<20110418082838.GA30088@hallyn.com>
Date: Tue, 19 Apr 2011 00:02:17 +0900
Message-ID: <BANLkTi=kxpFkQ86ZGd2_q+XFRm-nVWzw4g@mail.gmail.com>
Subject: Re: Linux capabilities shouldn't be lost during setuid to non-root
 from root or to another non-root uid from a non-root uid.
From: crocket <crockabiscuit@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have several questions.

1) How do I set SECBIT_NO_SETUID_FIXUP?

2) Is there any reason to unset SECBIT_NO_SETUID_FIXUP by default?

On Mon, Apr 18, 2011 at 5:28 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting crocket (crockabiscuit@gmail.com):
>> I don't like the fact that an application should be linux-specific to
>> keep capabilities after setuid.
>> If users added capabilities to a file, they would know what they were
>> doing, and they would want applications to keep capabilities even
>> after setuid.
>
> Alternatively, you could call the program using a wrapper which first
> sets the SECBIT_NO_SETUID_FIXUP securebit, after which setuid would
> not trigger any capability changes.
>
> -serge
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0L0K4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 05:56:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35965 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0L0K4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 05:56:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GUH8t3Rjcz7pjT74oTSdhNXZw3acoR2UgZ6auv09wuPWyf6JfROk65K1FC5Mkww1PT
         a0zN1+tx00aCGRY8+pPlbJW0OhFiFJtYf2Dn6tdy38GoCLLC333zNnqBMv+xRuooA1yJ
         uznbAgnLnnmuEMmwloOjO3p2txjn3wwRpKEVM=
Date: Mon, 27 Dec 2010 11:56:04 +0100
From: Tejun Heo <tj@kernel.org>
To: Niels <zorglub_olsen@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101227105604.GF11419@htj.dyndns.org>
References: <20101220141553.GA6088@bitwizard.nl>
 <20101220190630.66084e1d@neptune.home>
 <AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
 <20101222104306.GB30941@bitwizard.nl>
 <m3aajvz5na.fsf@intrepid.localdomain>
 <4D14BB36.1030304@msgid.tls.msk.ru>
 <if8ebj$nf8$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <if8ebj$nf8$1@dough.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 26, 2010 at 11:07:45PM +0100, Niels wrote:
> I have several of these drives, in various sizes. They seem to be aligned to
> 63 as you mention:
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1              63      208844      104391   83  Linux
> /dev/sda2          208845    19759949     9775552+  82  Linux swap / Solaris
> /dev/sda3        19759950   215094284    97667167+  83  Linux
> /dev/sda4       215094285   781417664   283161690   83  Linux
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1              63  1953520064   976760001   83  Linux
> 
> Is that bad?

Yes.

> What can I do to repair it?

Repartition it.

> What can I do to prevent it from happening again?

Use more recent distros.  Most distros released in the past six month
have partition utilties which honor partition alignment requirements.

Good luck.

-- 
tejun

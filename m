Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab1ESRAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:00:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63126 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554Ab1ESRAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:00:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eDYO/DWsJ7nH8DUrp8zxlnjNvmL4zQVKYRglZWjLJLlQcp72MEgNn8te7WibeBjAvZ
         P8bc8cr1rFoggUSid7lqhktbkLSM+wd6y+OPa0V+NN16RBSAYOetTEOiFSKvJ3DjoIJt
         AfAYab7sS3uYiCYpO5lnZ+qANG8+HQwTf405g=
MIME-Version: 1.0
In-Reply-To: <201105191526.31904.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
Date: Thu, 19 May 2011 19:00:35 +0200
Message-ID: <BANLkTi=FinuAYpYXf1K6pQ-3i2vRJS=g9g@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please CC also user-mode-linux-devel@lists.sourceforge.net,
so you can reach much more UML users. :)

2011/5/19 Toralf Förster <toralf.foerster@gmx.de>:
> I got a segfault as soon as I try to access the phpmyadmin web page of the UML
> instance at https://<uml_hostname>/phpmyadmin/  :

Hmm, strange.
phpmyadmin works fine on my UML test bed.
Can you bisect the issue?

-- 
Thanks,
//richard

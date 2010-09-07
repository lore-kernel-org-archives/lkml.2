Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0IGRBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:01:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46710 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab0IGRBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=V65jWvFl/n3QdSfy7SXIqtDxUTcP1wYi+V3h5JgXmzk+jQ58fW/Q1ypF8XP7U3lsIT
         vHv6+Ru/Acxdn7g7FNb7bHJeFUCvUmIxN8R50BHpV5Xp3+osxhjKmyHromdyVb4+LTz6
         rucQEfVqZngR11CgTb5vByo6iPBnKFViYmRBc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1009071236540.22515@localhost.localdomain>
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com> <alpine.LFD.2.00.1009071236540.22515@localhost.localdomain>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 7 Sep 2010 14:01:12 -0300
Message-ID: <AANLkTikEUDynxey8f3o7a4u-25Nbh7yn9HcWW4mVmGFX@mail.gmail.com>
Subject: Re: [RFC] Fix typos
To: Len Brown <lenb@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 13:47, Len Brown <lenb@kernel.org> wrote:
> The fixes to the ACPI and idle-related files below are correct
> and so I'll apply them now - thanks.
>
> drivers/acpi/acpica/exutils.c
> drivers/acpi/acpica/rsutils.c
> drivers/acpi/apei/Kconfig
> drivers/acpi/apei/erst-dbg.c
> drivers/acpi/apei/erst.c
> drivers/acpi/bus.c
> drivers/acpi/processor_perflib.c
> include/acpi/acpixf.h
>
> drivers/cpuidle/governors/menu.c
>
> It may be problematic to apply a single jumbo patch to the entire kernel
> b/c it will surely conflict with code that is changing.

I think at least for Documentation it can be applied all at once. I
reviewed again all changes to this directory and updated the patches
to my git repository:
git://git.profusion.mobi/users/lucas/linux-2.6.git spell-fix



Lucas De Marchi

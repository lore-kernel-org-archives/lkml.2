Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0LBEM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 23:12:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64721 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0LBEM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 23:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=q5DG7BeawWJMGzYaJ8fNfer7DKAhqryALoUH+S6htFTOOZJa/3ypiiurU+cbMgF3U7
         iQGqhg/7SgFdS6uuGuYHhOroqwQIP+uIZr/d0h8kcWv4v5kyy6Y3z6Y0UivsqV3ByLwZ
         TU45jGYtJSFY40RYd5lC4qv3AARkHC2a+ehLI=
MIME-Version: 1.0
In-Reply-To: <20101130153659.GE9418@sepie.suse.cz>
References: <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
 <4CC8ABC7.5030003@suse.cz> <20101028203542.GA30879@merkur.ravnborg.org>
 <4CC9E8C7.60306@suse.cz> <AANLkTinfsjy9GzDg1eHx+mFc4VabCZ2jk85JodFqRnEE@mail.gmail.com>
 <AANLkTimDUnaQ+Nax5Xz_TFmzPpj-20w7LOknL_WCKDdt@mail.gmail.com>
 <20101129143850.dbc533da.akpm@linux-foundation.org> <AANLkTi=3JQGZERNS7Uvbrs==dm0pJE_rGrcD_CkW2RDq@mail.gmail.com>
 <20101130153659.GE9418@sepie.suse.cz>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 1 Dec 2010 23:12:34 -0500
Message-ID: <AANLkTinzXqPmSyb0Rdvj9-a9jODoCYOEx+xZrBWeV-tr@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
To: Michal Marek <mmarek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 10:36, Michal Marek wrote:
> I deleted the Makefile change, which is now obsoleted by d63f6d1, the
> result would look like below. Mike, does mainline with this patch build
> on Blackfin now?

yes, it fixes things for me.  thanks !
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike

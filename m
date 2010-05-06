Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0EFQwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:52:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46957 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab0EFQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jEPXy1Zc9+ZFckq2UpZO/rKLLsJQebevsnKKV7eFB1Eb25eQHbHsOuZW80I+6xkv63
         axJEun6F0zsCs0diInhUHHFnJZceVXrvu9lMaswDTTcNKbQKAwdEYDdOHAfHZGO64LMo
         IxPfY1QVgYpFckMNTcOngrKLee3yXe2c6Lhyk=
MIME-Version: 1.0
In-Reply-To: <4BE2D10D.4070706@suse.cz>
References: <1273096160.23208.35.camel@mulgrave.site>
	 <4BE2D10D.4070706@suse.cz>
Date: Thu, 6 May 2010 18:52:28 +0200
Message-ID: <x2z19f34abd1005060952ta140dc7bx6b1280c1296d3c8c@mail.gmail.com>
Subject: Re: kbuild: fixing the select problem
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 May 2010 16:24, Michal Marek <mmarek@suse.cz> wrote:
> On a related note, I see Vegard's GSoC project to use a sat solver for
> kconfig got accepted [1]. Vegard, how is the project progressing?
>
> [1]
> http://socghop.appspot.com/gsoc/student_project/show/google/gsoc2010/psu_home/t127230762803

Hi,

Yes, that is true :-) I was planning to send an announcement to LKML
this weekend. Actual coding doesn't start until the last week of May.

So hopefully we can soon get rid of select altogether :-)


Vegard

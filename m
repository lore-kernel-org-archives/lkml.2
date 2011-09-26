Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab1IZRtC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:49:02 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41190 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1IZRtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:49:00 -0400
To: =?iso-8859-15?q?=C6var_Arnfj=F6r=F0_Bjarmason?= <avarab@gmail.com>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.7.rc3
References: <7vhb42su6f.fsf@alter.siamese.dyndns.org>
	<CACBZZX77ZhdS1cyiYpjJcuvSnJsv15FUumPWeZOcwh_b41c2FQ@mail.gmail.com>
From: Jakub Narebski <jnareb@gmail.com>
Date: Mon, 26 Sep 2011 10:48:56 -0700 (PDT)
In-Reply-To: <CACBZZX77ZhdS1cyiYpjJcuvSnJsv15FUumPWeZOcwh_b41c2FQ@mail.gmail.com>
Message-ID: <m3bou7p542.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ævar Arnfjörð Bjarmason wrote:
> On Sat, Sep 24, 2011 at 01:41, Junio C Hamano <gitster@pobox.com> wrote:
> 
> > Also the following public repositories all have a copy of the v1.7.7-rc3
> > tag and the master branch that the tag points at:
> 
> The 1.7.7-rc* series still doesn't compile on older Red Hat machines
> because 4c1be38b4a236403a329187acb70591a7fd92150 hasn't been included
> in it.
> 
> Could you please include that in the final 1.7.7? It would be a PITA
> to have to work around that.

It looks like I was too optimistic in

  "Re: What's cooking in git.git (Sep 2011, #06; Wed, 21)"
  http://thread.gmane.org/gmane.comp.version-control.git/181885/focus=181935

JN> Yes, that is what I mean... but that it is only because I use old
JN> version of asciidoc (7.1.2).
JN>  
JN> "make doc" (which is part of "make rpm") fails on my box with
JN> 
JN>       ASCIIDOC gitnamespaces.html
JN>   ERROR: gitnamespaces.txt: line 9: second section must be named SYNOPSIS
JN>   make[1]: *** [gitnamespaces.html] Error 1
JN> 
JN> > If the reason the documentation fix for "master" is needed is because a
JN> > new feature scheduled for the upcoming release has broken documentation,
JN> > then wouldn't we need the fix before the release, whether you are working
JN> > on your patch or not? How can it be not urgent if that is the case?
JN> > 
JN> > On my boxes with recent Debian, Ubuntu, and F14, I am not suffering from
JN> > the lack of the workaround, but if distros need the workaround, then the
JN> > time to apply it is now, not post release.
JN> 
JN> I don't think _modern_ distributions need this workaround... asciidoc 8.4.5
JN> which fixed the issue with "Synopsis" section was released 2009-05-24:
JN> 
JN> http://www.methods.co.nz/asciidoc/CHANGELOG.html
JN> 
JN>   Version 8.4.5 (2009-05-24)
JN>   --------------------------
JN>   Additions and changes
JN>   ~~~~~~~~~~~~~~~~~~~~~
JN> 
JN>     * Added manpage "Name" and "Synopsis" section title customization to
JN>       languages configuration files.
JN>     * "Synopsis" manpage section no longer mandatory.
JN>   [...]

-- 
Jakub Narębski

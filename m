Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2CEXXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:23:42 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45447 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2CEXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:23:40 -0500
Date: Tue, 6 Mar 2012 00:23:19 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5] EDAC core changes in order to properly report errors
 from all types of memory controllers
Message-ID: <20120305232319.GA7175@aftab>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
 <1330698314-9863-5-git-send-email-bp@amd64.org>
 <4F50DECB.8030200@redhat.com>
 <20120305110441.GC1070@aftab>
 <4F54A6FF.50502@redhat.com>
 <20120305124411.GD1070@aftab>
 <4F54C133.6040709@redhat.com>
 <20120305141349.GF1070@aftab>
 <4F54D4AF.9060802@redhat.com>
 <4F553764.5070305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F553764.5070305@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 07:00:04PM -0300, Mauro Carvalho Chehab wrote:
> With those changes, there's just one tracepont defined there, on this patchset:
> 	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=fdfa64045e43c942e1250708365d9240cd0da9c3

Ok, here's my take from simply skimming over the patchset for 5 mins:

* first of all, a lot of the patches are done sloppily and have no commit
messages whatsoever. This is a no-no and the first thing you need to fix.

* http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=ad015450e549b29a74283733048254d3c647a33at is humongous, has no commit message and contains a lot of changes which probably deserve a patch of their own. Mauro, you're not doing this since yesterday, you should know better!

* http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=ccca89bce4c0515aabd67440ba01ede97d2b4dcc removes crap introduced by earlier patches in the series, so also a no-no and needs to be fixed.

* WTF does the commit message of http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=c911a426ef72c817222e7c2ab302a81b69ccbd07 mean? Looks like it redacts a huge function you've introduced in an earlier patch... Hell, no!

...

* And, last but not least, your patches touch amd64_edac* extensively,
and, I need to properly review those changes before they get committed.

So, my absolutely sincere suggestion to you is to split this huge
patchset into smaller patchsets containing 5-10 patches, making it much
easier to review, go over <Documentation/SubmittingPatches> and refresh
your knowledge on how a proper patch should look like and what it should
contain, test your stuff properly on the machines it addresses and
_only_ _then_ send them to the relevant parties for proper review - not
earlier.

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

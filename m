Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0KGQjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:39:47 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64415 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0KGQjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:39:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=WBMYn3yPBVoRdyjjsJbuZUaKTwU+yz+wZvNxiH81fhrECZaebq0vMOC/yYnYkmTpzF
         jwBVoKlCuF4Drka4vG3OFmSUgH2W9aR/n9VcYSSvZ4se3qujRZdKNqP/05/Ug8ISM7Q5
         iaU+Cbm7P2oicIfmOKBXrvgi8lz6WNdL/ZPZs=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
In-Reply-To: <20101106162426.GA14361@merkur.ravnborg.org>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 07 Nov 2010 11:39:42 -0500
Message-ID: <87wropjdf5.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010 17:24:26 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
> Took a quick look.
> Does the following patch fix it?
> 
> if m == p then we will stay in the while look looking for a space.
> I did not audit all of the code - there may be other issues..
> 
Looks like something very strange is happening here. Debugging patch attached.

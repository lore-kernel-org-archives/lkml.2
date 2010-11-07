Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab0KGSJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:09:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48204 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab0KGSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=cskJI/dqfovcdW9L0Ld6x80rHrSOcL2Puh+q03261C8Q8s4zP+mnca3eC8WbyYoxiu
         SRODLAtOxdiwBiui54Puk13CCO7pBzMkMsSexhr4ywpw3S4qjC7FaV4EiXOZi5GKuv4z
         bBbKBB+WfZCk7f7t38g3kdBM39ZP9tNwAJ83Y=
From: Ben Gamari <bgamari.foss@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Christoph Egger <siccegge@cs.fau.de>, linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
In-Reply-To: <20101107170700.GA22684@merkur.ravnborg.org>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de> <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com> <20100729121002.GC13192@faui48a.informatik.uni-erlangen.de> <20100730084353.GB5638@cr0.nay.redhat.com> <87d3qicwxn.fsf@gmail.com> <87aalmcv0p.fsf@gmail.com> <20101106162426.GA14361@merkur.ravnborg.org> <87tyjtjd7m.fsf@gmail.com> <20101107170700.GA22684@merkur.ravnborg.org>
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sun, 07 Nov 2010 13:09:30 -0500
Message-ID: <87mxplypid.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010 18:07:00 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
> Interesting and valueable information!
> 
> Looks like fstat() failed for some odd reason
> Could you try to check the return value of fstat().
> 
fixdep: fstat failed: Invalid argument

Interesting indeed. According to my manpage fstat doesn't even return
EINVAL.

- Ben

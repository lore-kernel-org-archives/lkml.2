Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1IMFaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 01:30:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55393 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1IMFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 01:30:07 -0400
Date: Tue, 13 Sep 2011 13:30:07 +0800
From: Adam Lee <adam8157@gmail.com>
To: esmaeil mirzaee <esmaeil.debian@gmail.com>
Cc: kernelnewbies <kernelnewbies@kernelnewbies.org>,
        linux-kernel@vger.kernel.org
Subject: Re: maintenance time and git error
Message-ID: <20110913053007.GA21628@adam-station.nay.redhat.com>
Mail-Followup-To: esmaeil mirzaee <esmaeil.debian@gmail.com>,
	kernelnewbies <kernelnewbies@kernelnewbies.org>,
	linux-kernel@vger.kernel.org
References: <CAOwGe_yrRjq8Mqfcrm1P9bTYmPCA=qhNBxide10_w5ceR6wkDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOwGe_yrRjq8Mqfcrm1P9bTYmPCA=qhNBxide10_w5ceR6wkDg@mail.gmail.com>
X-PGP-Key-ID: D15CA3BE
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 01:22:05AM -0400, esmaeil mirzaee wrote:
> Hi
> does anyone know when the maintaining of the web page www.kernel.org
> will be finish?
> and when I try this "git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux2.6.git
> linux
> 
> I got below error
> "Initialized empty Git repository in /home/esmaeil/fixbug/krl/linux/.git/"
> "fatal: Unable to look up git.kernel.org (port 9418) (Name or service
> not known)"
> 

It will be back in few days.

If you wanna get updated, you can:

$ git remote add github git://github.com/torvalds/linux.git
$ git fetch github
$ git checkout -b github github/master

and you will get a branch named "github" with github remote.

-- 
Regards,
	Adam Lee
	--------------------------------------------------
	E-mail: adam8157@gmail.com
	Website: http://www.adam8157.info
	--------------------------------------------------

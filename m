Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab0FCJcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:32:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39802 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933569Ab0FCJcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h/tJRqNrCAY4L12KyLco9dFiKPz9aDZLUXiCFx71P++83Ad/M1sFVx20KAZvDcGu6c
         AuBisJOGvqzfAxjc8T8hBXZApuhLoxcWvLemeJtwZBytGpvo0olOxkBLrNlb5hCEdnh7
         JOs5fxP5oiKi4U+ueE052zOA2TYsHVa4hh0KM=
Subject: Re: [PATCH] kobject: Suppress compiler warning with gcc 3.x
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       ebiederm@aristanetworks.com, randy.dunlap@oracle.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100603085711.GD5580@cr0.nay.redhat.com>
References: <201006030523.o535NA16029042@www262.sakura.ne.jp>
	 <1275543101.29413.76.camel@edumazet-laptop>
	 <20100603055515.GA5580@cr0.nay.redhat.com>
	 <m1y6ewr6vf.fsf@fess.ebiederm.org>
	 <20100603062314.GB5580@cr0.nay.redhat.com>
	 <m1k4qgr54j.fsf@fess.ebiederm.org>
	 <20100603085711.GD5580@cr0.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 11:32:02 +0200
Message-ID: <1275557522.2456.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 03 juin 2010 à 16:57 +0800, Américo Wang a écrit :

> 
> Yeah.
> 
> However, this compile warning only appears in gcc 3.x
> and it seems it's a fault of gcc 3.x, not the code. I am wondering
> if we need to fix it.
> 

I believe gcc-3 was born before the code you mention.

We can keep ability to compile kernel on old gcc for very litle care.

Lets do it please, unless there is a real show-stopper, not because
we feel gcc-3 is 'old'



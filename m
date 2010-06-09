Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab0FIFXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 01:23:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39006 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0FIFXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 01:23:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=L/Yl7rX812B9c150U3Zml0somJInwSg9qWWt7Qn3rL/dEuWz/UFuClVLyvbo1NYgp6
         uaEd1NwfKJUQJDCB2owTtMUSUR9mCtB6lkChdFbrFfOKUxwgvCOtkqtojL7oPjqlmwEh
         OgijBZaNrnqAtUhJRQsugCVFK/c2h+BbnaI/o=
Subject: Re: [GIT PULL] UBI changes for 2.6.35-rc3
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006081307450.4506@i5.linux-foundation.org>
References: <20100608084752.11914.19793.sendpatchset@localhost.localdomain>
	 <alpine.LFD.2.00.1006081307450.4506@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 08:23:11 +0300
Message-Id: <1276060991.17909.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 13:08 -0700, Linus Torvalds wrote:
> 
> On Tue, 8 Jun 2010, Artem Bityutskiy wrote:
> > 
> > please, pull few UBI changes which fix corrupted empty flash
> > handling:
> 
> I'm currently not pulling stuff that isn't regression fixes (or major 
> things like security issues and oopses).

Understood, this can easily wait.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


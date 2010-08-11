Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab0HKTS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:18:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab0HKTS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=LWxzH3yVxTVI5sp49O+FekC+uLbEXYn7yTA5o1fCt0fJYYREz23vTLzTmX9IC7Odaq
         +lQ6Ksx9TwBJ6z1r6iHQtOuEe/6VBk8Zgw39JOe1t59CqzdAAI8Gf18cEg/TOJ0zoA5N
         uFjGg0aiwJeZxOC9m9ZfoVV2U0/bfDEh484xc=
MIME-Version: 1.0
In-Reply-To: <1281552896.3058.41.camel@gandalf.stny.rr.com>
References: <1281079584-21205-1-git-send-email-vapier@gentoo.org> 
	<1281552896.3058.41.camel@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 11 Aug 2010 15:18:03 -0400
Message-ID: <AANLkTikCyULM3Mc25hJJn_cD=vWnWwgbi5qxoHDHA2kn@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] tracing: extend recordmcount to 
	better support Blackfin mcount
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 14:54, Steven Rostedt wrote:
> You want me to pull it? or should this go via another tree?

i was planning on it going through your tree ;)
-mike

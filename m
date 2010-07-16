Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab0GPWuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:50:05 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61160 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0GPWuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=waqE+RenWNp02wVp7odFOi5SIiXD7Ql6vls6H/EOV/wFSZXciT0/BACgHwI7JqKMXa
         AiDn47SXCY+RiEL3otOis80royoQdVf2v3N4sfItY/aWx8nZocGMP/J21oq+cB+ApgKL
         SbesG5LH7z4UXGtBanDXJEUfEaYRDAKupL7v8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikwWezvqiW-ts__stLfofKbaqG8CSzOYvDQuxhu@mail.gmail.com>
References: <AANLkTineI34tKDMPYN4SPY0W432cv8ZPc55IEW5hwmed@mail.gmail.com>
	<AANLkTikwWezvqiW-ts__stLfofKbaqG8CSzOYvDQuxhu@mail.gmail.com>
Date: Fri, 16 Jul 2010 16:50:01 -0600
Message-ID: <AANLkTilvKpfBHwBwz7_IV81_PZ-SUvZK8GkYmtYnufqx@mail.gmail.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> If it was just the debug issue, I'd say "neener neener, debuggers are
> for wimps", but it's clearly not just about debug. It's a whole lot of
> other thigs. Random percpu datastructures used for tracing, kernel
> pointer verification code, yadda yadda.
>
>                  Linus
>

I guess I am a wimp then ... :-)

Jeff

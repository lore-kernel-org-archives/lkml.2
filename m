Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0KAHaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 03:30:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38417 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0KAHaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 03:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=o1TZFvtgNCwRzBlzhCHk9udsOWZSvmDUzFOeFLPyCYJowXjXbYERr1oTdmuhIqz5Dv
         m1NwMnz4TnpUKVRIWBtD8qqB8XAqpbhprxo03/x/BmuFQbUEaJdQ2yKzlzc4EJwE95Gl
         1DjKKusni6eNTxwKGvlGbUCumUFOpwg8fmDqo=
MIME-Version: 1.0
In-Reply-To: <20101101040611.GA5850@penfold>
References: <AANLkTi=sR+wTN1MSRZLW1qB99ybGgOTbUJuw8drtbwA5@mail.gmail.com> <20101101040611.GA5850@penfold>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 1 Nov 2010 08:29:40 +0100
X-Google-Sender-Auth: qFjiFHhTqm-JDQLIdPmbpeUedOc
Message-ID: <AANLkTiknBbdUji2mATH159US1J_yJE5egOFkU4TH5jdb@mail.gmail.com>
Subject: Re: New 2.6.36 checkpatch complaints about leading whitespace
To: Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Vladislav Bolkhovitin <vst@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 5:10 AM, Andy Whitcroft <apw@canonical.com> wrote:
>
> On Sat, Oct 30, 2010 at 11:35:22AM +0200, Bart Van Assche wrote:
> > Hello Andy,
> >
> > Apparently the checkpatch.pl script as included in 2.6.36 complains if
> > continued lines start with whitespace. An example:
> >
> > [ ... ]
> > +#if defined(MACRO_NAME_1) || defined(MACRO_NAME_2) \
> > +  || defined(MACRO_NAME_3)
> > [ ... ]
> >
> > checkpatch.pl reports the following warning for the above patch excerpt:
> >
> > WARNING: please, no space for starting a line,
> >                                 excluding comments
> >
> > Is that a feature or an unintended side effect of recent checkpatch changes ?
>
> My personal expectation would be for that second line to be indented
> with a tab.  But I might be convinced otherwise?

There are also other preprocessor directives on which the 2.6.36
checkpatch complains, e.g.:

#warning A very long warning message that takes multiple lines and of which\
 the second line starts with a space.

Why does the 2.6.36 checkpatch complain that the second line should
start with a tab instead of a space (which would make the message
really ugly) ?

Bart.

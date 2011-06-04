Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1FDROJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 13:14:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41029 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1FDROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 13:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=d95aPBbDUhz9Nnob79TxEIlzBHTbCUthU0ACy74P7KxCr4jTFgtuZKnKD0La+XRhA5
         Z5ypO6ENj4hO5/7X7XUEXco1xtkK2ABNfYe/weMpeDq8lB02VBrc/Q0CIywXm9LeIGE7
         3UvhDZqJYmt6NNnHMHJj226YFlBxOYJDQAbeU=
MIME-Version: 1.0
In-Reply-To: <1307116529.2669.130.camel@novo.hadess.net>
References: <4DE1FA7F.3050308@users.sourceforge.net> <1307116529.2669.130.camel@novo.hadess.net>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Sat, 4 Jun 2011 19:13:47 +0200
Message-ID: <BANLkTinz12uYphhORTwGf202j-ofZi2sKJ+KoL7Auuga3NbrEA@mail.gmail.com>
Subject: Re: Reporting screen/laptop orientation data to userspace
To: Bastien Nocera <hadess@hadess.net>
Cc: Alberto Mardegan <mardy@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, "Javier S. Pedro" <maemo@javispedro.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 5:55 PM, Bastien Nocera <hadess@hadess.net> wrote:
>
> As soon as it's seen some testing, I'll be showing the work I did for
> GNOME support for automatic rotation based on orientation.

And how you handle these events through X ?

i

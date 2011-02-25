Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab1BYPyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:54:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36511 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab1BYPyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:54:37 -0500
MIME-Version: 1.0
In-Reply-To: <4D67AEEE.30000@ru.mvista.com>
References: <20110223021524.18318.71902.stgit@localhost6.localdomain6>
 <20110223022234.18318.90592.stgit@localhost6.localdomain6>
 <4D657880.50405@ru.mvista.com> <20110223213601.GA5404@angua.secretlab.ca> <4D67AEEE.30000@ru.mvista.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 25 Feb 2011 08:54:17 -0700
X-Google-Sender-Auth: IwjZgKlxE0bVNu7OxTN318gBhpA
Message-ID: <AANLkTimcKkkRUSHOKo89ufZ4JfexsgKhUTHNroZqWH7_@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] arm/dt: Basic tegra devicetree support
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 6:30 AM, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> On 24-02-2011 0:36, Grant Likely wrote:
>>>> v2: Fixed cut-and-paste error in commit text
>
>>>    Shouldn't this sentence follow the --- tearline?
>
>> Nope!  It is actually quite useful for the version information to show
>> up in the commit text.  That way you know *exactly* which version got
>> merged.  dwmw2 pointed that out to me a few months back.
>
>   Well, I think that depends on the patch. If you have say 9 revisions with
> significant changes (that's what I actually had) and the revision history
> far exceeds the original patch description, then this will just become too
> ugly I think...

Meh.  commit text is cheap and useful.

g.

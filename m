Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab1EWQjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:39:25 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:60627 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756546Ab1EWQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:39:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KT5m7CsqEv2Abw+jcUxQygdDfRIXnpslIJsWc0VvtzMKTLHA4dZc7PXpyUfJCQhWKZqu7ti9T/4fzu0gVWxHWniHW5sZtoCc5ZYCMMFrQtWrYEr8eW1be1J3MgKK9891;
Date: Mon, 23 May 2011 09:39:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Joe Perches <joe@perches.com>
Cc: anish singh <anish198519851985@gmail.com>, davej@redhat.com,
        rostedt@goodmis.org, apw@shadowen.org, akpm@linux-foundation.org,
        vapier@gentoo.org, linux-kernel@vger.kernel.org, man.k1983@gmail.com
Subject: Re: [patch v3] checkpatch: Signature format verification
Message-Id: <20110523093920.8f1e5cd0.rdunlap@xenotime.net>
In-Reply-To: <1306168598.8687.27.camel@Joe-Laptop>
References: <1306006721.1622.18.camel@anish-desktop>
	<1306059528.2761.3.camel@anish-desktop>
	<1306164094.2292.25.camel@anish-desktop>
	<1306167105.8687.11.camel@Joe-Laptop>
	<BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com>
	<1306168598.8687.27.camel@Joe-Laptop>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 09:36:38 -0700 Joe Perches wrote:

> On Mon, 2011-05-23 at 22:03 +0530, anish singh wrote:
> > \s[a-zA-Z]* => this is a regular expression for name & space b/w
> > Last/First name
> >                     Ex: anish kumar
> > .* => It is used to grep whatever follows name...in our context
> > mail-id
> >         Ex: abc@bbc.com.
> > So, $1 will contain ...'anish kumar <anish@gmail.com>'
> 
> Unless the email contains a quote or a period like:
> 
> Signed-off-by: "J. Random Contributor" <jrc@domain.tld>

and quotes are not required (i.e., are optional) AFAIK.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

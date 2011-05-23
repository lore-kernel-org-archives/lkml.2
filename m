Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab1EWQgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:36:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1876 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab1EWQgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:36:40 -0400
Subject: Re: [patch v3] checkpatch: Signature format verification
From: Joe Perches <joe@perches.com>
To: anish singh <anish198519851985@gmail.com>
Cc: davej@redhat.com, rostedt@goodmis.org, apw@shadowen.org,
        akpm@linux-foundation.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
In-Reply-To: <BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com>
References: <1306006721.1622.18.camel@anish-desktop>
	 <1306059528.2761.3.camel@anish-desktop>
	 <1306164094.2292.25.camel@anish-desktop>
	 <1306167105.8687.11.camel@Joe-Laptop>
	 <BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 09:36:38 -0700
Message-ID: <1306168598.8687.27.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 22:03 +0530, anish singh wrote:
> \s[a-zA-Z]* => this is a regular expression for name & space b/w
> Last/First name
>                     Ex: anish kumar
> .* => It is used to grep whatever follows name...in our context
> mail-id
>         Ex: abc@bbc.com.
> So, $1 will contain ...'anish kumar <anish@gmail.com>'

Unless the email contains a quote or a period like:

Signed-off-by: "J. Random Contributor" <jrc@domain.tld>




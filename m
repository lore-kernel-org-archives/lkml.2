Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1AUBl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 20:41:27 -0500
Received: from mail.perches.com ([173.55.12.10]:3229 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab1AUBl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 20:41:26 -0500
Subject: Re: [PATCH 0/7] Nexus One Support
From: Joe Perches <joe@perches.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Dima Zavin <dmitriyz@google.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org
In-Reply-To: <1295571359.9236.53.camel@m0nster>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
	 <AANLkTik+HCj9dkD2s4WgwCqKWCXDbdSnKDUbyGfYfaPr@mail.gmail.com>
	 <1295571359.9236.53.camel@m0nster>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 17:41:25 -0800
Message-ID: <1295574085.4096.6.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 16:55 -0800, Daniel Walker wrote:
> On Thu, 2011-01-20 at 16:42 -0800, Dima Zavin wrote:
> > You are not the author of any of these patches. Where are the author
> > attributions for the team that actually wrote this code?
> In the commit text.. The author field is used to denote who authored the
> commit, which in this case is me.

You have that wrong.
Author and Committer are different git fields.

http://www.kernel.org/pub/software/scm/git/docs/user-manual.html

      * an author: The name of the person responsible for this change,
        together with its date.
      * a committer: The name of the person who actually created the
        commit, with the date it was done. This may be different from
        the author, for example, if the author was someone who wrote a
        patch and emailed it to the person who used it to create the
        commit.



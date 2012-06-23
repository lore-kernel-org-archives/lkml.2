Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2FWUv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 16:51:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50105 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754732Ab2FWUv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 16:51:56 -0400
Message-ID: <1340484715.7758.22.camel@joe2Laptop>
Subject: Re: [PATCH V2 1/3] staging/rtl8192u: fix coding style problems
From: Joe Perches <joe@perches.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 23 Jun 2012 13:51:55 -0700
In-Reply-To: <CAHdPZaMH1vJPsFmGFrrpWNtCxuY+S35-w2j+gbiiE=7jVKLtUQ@mail.gmail.com>
References: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
	 <20120620230839.GA17883@kroah.com> <1340234315.29885.54.camel@joe2Laptop>
	 <CAHdPZaMH1vJPsFmGFrrpWNtCxuY+S35-w2j+gbiiE=7jVKLtUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-24 at 00:04 +0530, devendra.aaru wrote:
> Hi Joe,

Hi Devendra.

> On Thu, Jun 21, 2012 at 4:48 AM, Joe Perches <joe@perches.com> wrote:
> > I'd just make the return a bool instead.

>  taking another variable and assign it like bool ret = !!bit, and
> returning ret?, i think this doesn't look better.

No. just
	return val;
or
	return (bool)val;

if using the implicit conversion bothers you.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2EHVWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:22:00 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab2EHVV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:21:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both: draft
Date: Tue, 8 May 2012 23:26:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <1336379825.2097.5.camel@shrek.rexursive.com> <201205072214.13912.rjw@sisk.pl> <1336446956.2097.16.camel@shrek.rexursive.com>
In-Reply-To: <1336446956.2097.16.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205082326.42970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012, Bojan Smojver wrote:
> On Mon, 2012-05-07 at 22:14 +0200, Rafael J. Wysocki wrote:
> > Looks reasonable at first sight.
> 
> OK, thanks for having a look! I'll check to see whether memory for
> hibernation is been released properly and then I may submit this for
> real. BTW, the patch actually worked on my ThinkPad T510. The miracles
> never stop. :-)
> 
> Just to be sure - I should prepare a patch against your linux-next
> branch, correct?

Yup.

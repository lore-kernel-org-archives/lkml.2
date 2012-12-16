Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2LPMCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:02:11 -0500
Received: from web24.pochta.ru ([62.141.94.204]:63843 "EHLO web24.pochta.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2LPMCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:02:09 -0500
From: tux2002@front.ru
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: =?utf-8?Q?Re:=20Re:=20[PATCH]=20subsystem:=20pr=C2=ADoc=20filesystem?=
In-Reply-To: <20121213162207.GP4939@ZenIV.linux.org.uk>
References: <20121213162207.GP4939@ZenIV.linux.org.uk>
Date: Sun, 16 Dec 2012 16:02:03 +0400
Message-Id: <5dca9c1a0bb851ebaa08ffb05941f90454ea3d6a@mail.qip.ru>
X-Priority: 3
X-QIP-Sender: 109.161.123.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-NoSpam-Exim-Host: 62.141.94.133
X-NoSpam-Exim-Port: 8092
X-NoSpam-Exim-Scanned: Yes
X-NoSpam-Exim-Result: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not, this permissions saved for all users for later, check please.



Чтв 13 Дек 2012 20:22:10 +0400, Al Viro <viro@ZenIV.linux.org.uk> написал:

> On Thu, Dec 13, 2012 at 05:15:44PM +0400, tux2002@front.ru wrote:

> > 

> > 

> > This patch strengthens file permissions of pid record in proc filesystem. When pid and pidentry records created, his permissions strengthens by creator umask.

> > 

> 

> NAK.  "Creator" in this case means "whoever had done lookup first".

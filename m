Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab2GHW6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:58:21 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:26978 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2GHW6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:58:20 -0400
Date: Mon, 9 Jul 2012 00:58:18 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3][v2] staging: vt6656: iwctl: mop up a few remaining
 obvious style issues.
In-Reply-To: <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207090052220.15263@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net> <20120706230945.GA8835@kroah.com> <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My previous 14 patch series to vt6656 missed a few bits and pieces.
This small followup series mops up the last few obvious style issues.
It is quite short and completely trivial - simply deletes a few blank 
lines, does some whitespace cleanup around operators and fixes a few curly 
braces.
The series is on top of linux-next (next-20120706).

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


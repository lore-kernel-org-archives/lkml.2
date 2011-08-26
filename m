Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1HZV3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 17:29:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63896 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1HZV3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 17:29:09 -0400
MIME-Version: 1.0
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 26 Aug 2011 17:28:48 -0400
Message-ID: <CAGZ=bqKikkiw9U8eYBzBpybPHr5_YUfG-BZe3vJCkNXodaoaUg@mail.gmail.com>
Subject: Database error on bugzilla.kernel.org
To: linux-kernel@vger.kernel.org, webmaster@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Not sure who the right address to contact is, but...

The kernel Bugzilla was loading glacially slowly a few minutes ago,
and now seems to be showing this error:
> Software error:
>
> Can't connect to the database.
> Error: Host 'demeter1.sql.kernel.bak' is blocked because of many connection errors; unblock with 'mysqladmin flush-hosts'
>   Is your database installed and up and running?
>   Do you have the correct username and password selected in localconfig?
>
> For help, please send mail to the webmaster (root@localhost), giving this error message and the time and date of the error.

Hopefully this doesn't get lost in the noise.

Cheers,
Kyle Moffett

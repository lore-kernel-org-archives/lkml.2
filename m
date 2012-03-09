Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab2CIS3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:29:02 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49864 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab2CIS3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:29:00 -0500
Message-ID: <4F5A4BE7.60308@gmail.com>
Date: Fri, 09 Mar 2012 23:58:55 +0530
From: Prasanna Kumar T S M <prasannatsmkumar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Git pull on linux-next tree shows "Performing inexact rename detection"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing "git pull" on linux-next tree always shows "Performing inexact
rename detection" for a very long time (more than a hour and going). It
also uses more than 1.5GB of RAM (out of 2GB RAM) in my system. Not able
to do any thing when this is happening - even maximising a window takes
2 minutes once such a situation is reached. I am killing the command
with a Ctrl + C as I am not able to do any work.

What is the reason for this? What it does internally? Is there any way
to circumvent this? I don't want to clone linux-next again (that seems
to be the worst case solution).

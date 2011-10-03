Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1JCC5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 22:57:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36878 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1JCC5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 22:57:10 -0400
Message-ID: <4E892483.7070605@lwfinger.net>
Date: Sun, 02 Oct 2011 21:57:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110922 Thunderbird/7.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: git problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had my system freeze when doing a pull from Linus's repo. Since then, every 
pull results in the following errors:

~> git pull
error: unable to resolve reference refs/tags/v3.1-rc8: Success
 From git://github.com/torvalds/linux
  ! [new tag]         v3.1-rc8   -> v3.1-rc8  (unable to update local ref)

Any suggestions on how to fix this error?

Thanks,

Larry

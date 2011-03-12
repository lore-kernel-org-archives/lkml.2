Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1CLBrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:47:21 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44419 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1CLBrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:47:19 -0500
Date: Fri, 11 Mar 2011 22:47:49 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [2.6.38-rc8, patch] fix hci_dev_list locking
Message-ID: <20110312014749.GB2164@joana>
Mail-Followup-To: Daniel J Blueman <daniel.blueman@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
References: <AANLkTinN=eYJB3wF9jw7vbbTtUgOzr8oap4+i21Uei5X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinN=eYJB3wF9jw7vbbTtUgOzr8oap4+i21Uei5X@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

* Daniel J Blueman <daniel.blueman@gmail.com> [2011-03-09 00:07:54 +0800]:

> No response from original post, and it missed getting taken into -rc7
> and -rc8, so repost:
> 
> Release acquired lock on error path, fixing potential hang up.

I already have a patch like this one in my tree, thanks anyway. :)

-- 
Gustavo F. Padovan
http://profusion.mobi

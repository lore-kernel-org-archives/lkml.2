Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1K3PYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:24:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40765 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab1K3PYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:24:33 -0500
Message-ID: <4ED64AAC.5040405@gmail.com>
Date: Wed, 30 Nov 2011 07:24:28 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, rjw@sisk.pl
Subject: suspend broken with macbookpro2,2 with the current Mainline
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seem to be hitting an issue with suspend on the current mainline.
basically once I close the lid everything seems to work, even waking 
up(opening the lid), but if I close the lid and go to work I come back 
to my machine off(shutdown) after a few hours of being suspended.

last good kernel I have is:
3.0.0-13-generic
which is ubuntus generic kernel. I am in the process of starting a 
bisect but will take some time due to complete. if anybody is seeing 
this, and knows a fix let me know.

Justin P. Mattock

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912Ab1HLGQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:16:43 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36273 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1HLGQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:16:41 -0400
Message-ID: <4E44C537.8040101@gmail.com>
Date: Thu, 11 Aug 2011 23:16:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: i915 suspend crash: BUG: unable to handle kernel NULL pointer deferrence
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im getting a freeze with the current Mainline using an inspiron 1200.
I have posted images of no_console_suspend=1

http://www.flickr.com/photos/44066293@N08/6034687244/
http://www.flickr.com/photos/44066293@N08/6034131811/

Note: these are images of suspending the machine on two occasions
(removing the battery gave me more message on the screen).

I can try for a bisect, but might not be able to do so due to time 
constraints and things.
(if there is any patches to try and test let me know!)

Justin P. Mattock

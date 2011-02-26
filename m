Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1BZIYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 03:24:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33823
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab1BZIYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 03:24:46 -0500
Date: Sat, 26 Feb 2011 00:25:23 -0800 (PST)
Message-Id: <20110226.002523.39185761.davem@davemloft.net>
To: mhocko@suse.cz
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        torvalds@linux-foundation.org, ebiederm@xmission.com
Subject: Re: Another list corruption in networking stack with
 2.6.38-rc6-00020-gd8204a3?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110226082149.GA9623@tiehlicka.suse.cz>
References: <20110226082149.GA9623@tiehlicka.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>
Date: Sat, 26 Feb 2011 09:21:49 +0100

> I am currently on 2.6.38-rc6-00020-gd8204a3 which already contains some
> list_del fixes but I remember that there were still some of them
> pending. I can really see at least 5f04d5068 which I do not have. Is it
> possible that it fixes the above corruption? 

That commit absolutely will fix your bug.

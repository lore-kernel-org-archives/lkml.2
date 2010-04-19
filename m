Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0DSO3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:29:44 -0400
Received: from lo.gmane.org ([80.91.229.12]:36459 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab0DSO3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:29:43 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [patch] vt: deactive Shift In/Out in unicode mode
Date: Mon, 19 Apr 2010 20:29:19 +0600
Message-ID: <4BCC68BF.6090300@gmail.com>
References: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 94.50.113.200
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.1.9) Gecko/20100410 Gentoo/2.0.4-r1 SeaMonkey/2.0.4
In-Reply-To: <alpine.LSU.2.01.1004191555290.17067@obet.zrqbmnf.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> vt: deactive Shift In/Out in unicode mode
>
> WP describes these control codes as: "The original meaning of those
> characters was to switch to a different character set and back.  This
> was used, for instance, in the Russian character set known as KOI7,
> where SO starts printing Russian letters, and SI starts printing Latin
> letters again."

Since KOI7 is not used by any glibc locale, your use case is now 
extinct. I think that, unless someone finds out a different use case, 
these SI and SO characters should be deactivated completely (and not 
just in unicode mode).

-- 
Alexander E. Patrakov


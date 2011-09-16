Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1IPVF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:05:27 -0400
Received: from mail.anarazel.de ([217.115.131.40]:45814 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab1IPVF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:05:26 -0400
From: Andres Freund <andres@anarazel.de>
To: pgsql-hackers@postgresql.org
Subject: Re: [HACKERS] Improve lseek scalability v3
Date: Fri, 16 Sep 2011 23:05:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc5-andres; KDE/4.6.5; x86_64; ; )
Cc: Benjamin LaHaise <bcrl@kvack.org>, Matthew Wilcox <matthew@wil.cx>,
        Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        robertmhaas@gmail.com
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <20110916200817.GD28519@kvack.org> <201109162302.38780.andres@anarazel.de>
In-Reply-To: <201109162302.38780.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109162305.18696.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 16, 2011 11:02:38 PM Andres Freund wrote:
> Also with fstat() instead of lseek() there was no bottleneck anymore, so I 
> don't think the benefits would warrant that.
At least thats what I observed on a 4 x 6 machine without the patch applied 
(can't reboot it). That shouldn't be concurrency relevant so...

Andres

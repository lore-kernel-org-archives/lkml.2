Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab0IUH75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:59:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0IUH7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:59:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: manual merge of the bkl-vfs tree with the cifs tree
Date: Tue, 21 Sep 2010 09:59:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        linux-cifs@vger.kernel.org, Jan Blunck <jblunck@infradead.org>
References: <20100921161031.7745150e.sfr@canb.auug.org.au> <AANLkTikbM17xs41abm+6DTa9DJLYM8XYeVg=bZr_n8M5@mail.gmail.com>
In-Reply-To: <AANLkTikbM17xs41abm+6DTa9DJLYM8XYeVg=bZr_n8M5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009210959.50115.arnd@arndb.de>
X-Provags-ID: V02:K0:V8SrW6MiE4r/hT+6y0J7OxzCeNM75QP6LT2xy8IoxzE
 BiXE6if1+JkjTcbgy1YUxuR15700AGRnZytTjTm63CPGoaaFHA
 +LT0/GVJ2zd/xL35B7yHo2fnoQ762wUSkj7hxZo3Tua9fS/S++
 KljodtLBBMtjvSEvs8ighIkHqNYEyoDsPC81y4bLfOdRpSrOvD
 7F/4HbsFLLhmNTo2c7FFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 September 2010, Steve French wrote:
> Alternatively - I could merge the trivially modified bkl cifs patch
> into the cifs-2.6.git tree if that is easier

Well, this is the most trivial sort of conflict, I guess we don't have
to worry about it.

Part of my patch reverts part of an earlier patch in the bkl-vfs series
(by design, not by accident).
We could sort that out, but my feeling is that it's not worth it.

	Arnd

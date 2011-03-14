Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab1CNBpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 21:45:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34119 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1CNBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 21:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jLJqRcuJc3zdoyjEDuGuH9+mCGoqmq6IxuNlWSMyHQ9xxMULpQ/TpRAls66n/wa9c1
         pcbHGIakx3S4SAke/M+QrSC7yH1R3vYeLyupGZKxZXKhzIhH1May+FRHawaHuk1Rj3vg
         bktYBI+RwAyXz7z5xxuqJFdvOYikuaLcibH4o=
Message-ID: <4D7D7325.2040708@garzik.org>
Date: Sun, 13 Mar 2011 21:45:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Ric Wheeler <ricwheeler@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org, mtk.manpages@gmail.com,
        viro@zeniv.linux.org.uk, hch@lst.de, l@jasper.es
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl> <201103111255.44979.arnd@arndb.de> <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl> <4D7AC0FE.8070806@gmail.com> <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl> <4D7ADFDD.9080108@gmail.com> <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl> <4D7BBC03.3020404@garzik.org> <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
In-Reply-To: <89481603ed9cfc86efaa039c2dfeb955.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2011 09:31 PM, Indan Zupancic wrote:
> The new syscall works on only one fd too. The behaviour of the proposed
> syncfs and an extended sync_file_range is exactly the same.

No, it's not.  You should read the patch before commenting.

	Jeff




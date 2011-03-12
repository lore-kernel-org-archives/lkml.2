Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1CLSbh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 13:31:37 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47651 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1CLSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 13:31:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uzmDpxFzCss7O9wJEd+qgGaf2c8Jc95898CqY65srWsisq/9Jh8HEKRl8SLJuBd0Xn
         RSWpmYAiY5+airPjdcis+qZwfuyTXvWg59Fc1jV1A1boQPf2f0jrU5Nn1uIk3X1tblss
         w3N1Vo1/Wg4iToz4+KRgXVZMt5GI4UwSoKoPU=
Message-ID: <4D7BBC03.3020404@garzik.org>
Date: Sat, 12 Mar 2011 13:31:31 -0500
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
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl> <201103111255.44979.arnd@arndb.de> <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl> <4D7AC0FE.8070806@gmail.com> <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl> <4D7ADFDD.9080108@gmail.com> <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
In-Reply-To: <e118a1458c29e4f44bf71c7095e4bce8.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 10:50 PM, Indan Zupancic wrote:
> If sync(2) didn't exist and people wanted to add it I'd complain too. This
> has all the problems of sync(2), but with the "not sure if all the files are
> on the file system I think" problem added.

You are decades too late, then...

sync_file_range() is not appropriate because that works on only one fd.

The new syscall is fine, and addresses a need.

	Jeff



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0HPF35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 01:29:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39981 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0HPF3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 01:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VYweAEeRmECSFhl2svjZiyhp7nAOPo9Azf2DUDm0SizHMN7JYoJidWD+F9zGs4Kusn
         jp2A72+tPKuNep0PIv0a0XyrPquZ0toz6XlLk/d1mQvqh4L5URD6SkcpIA7paZj9Gpgw
         GQ5ce8TZWFZWTUbZhDHrRgyd50Bqj5JTFnquo=
Message-ID: <4C68CCCD.5060303@gmail.com>
Date: Mon, 16 Aug 2010 13:29:49 +0800
From: "Mr. Teo En Ming (Zhang Enming) of Singapore" 
	<space.time.universe@gmail.com>
Reply-To: space.time.universe@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "space.time.universe@gmail.com" <space.time.universe@gmail.com>,
        "teoenming@hotmail.com" <teoenming@hotmail.com>,
        zhang_enming@lavabit.com
Subject: Re: [Xen-devel] Xen patches merged to upstream Linux 2.6.36,	plans
 for 2.6.37?
References: <20100815160904.GM2804@reaktio.net>
In-Reply-To: <20100815160904.GM2804@reaktio.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good news! Good news! Xen pv-ops dom0 is finally just starting to get 
merged into upstream Linux...

Starting with Linux 2.6.36....

Yours sincerely,

Mr. Teo En Ming (Zhang Enming)
Citizenship: Singapore Citizen/Singaporean
Facebook account: Teo En Ming (Zhang Enming)
Facebook link:http://www.facebook.com/profile.php?id=100000750083982
Facebook photos:
http://www.facebook.com/profile.php?id=100000750083982#!/profile.php?id=100000750083982&v=photos  <http://www.facebook.com/profile.php?id=100000750083982#%21/profile.php?id=100000750083982&v=photos>
Facebook videos:
http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137  <http://www.facebook.com/profile.php?id=100000750083982&v=app_2392950137>
Mobile Phone (Starhub pre-paid): +65-8369-2618
Windows Live Messenger:teoenming at hotmail.com  <https://admin.fedoraproject.org/mailman/listinfo/users>
Location: Bedok Reservoir Road, Singapore
ZIP: 470103
My Open Letter (Plea for Medical Help/Assistance) to World Leaders:-
http://lists.mcs.anl.gov/pipermail/mpich-discuss/2010-August/007693.html
http://lists.fedoraproject.org/pipermail/users/2010-August/380213.html
http://mythtv.org/pipermail/mythtv-users/2010-August/294733.html



On 08/16/2010 12:09 AM, Pasi Kärkkäinen wrote:
> Hello,
>
> It looks like upstream linux-2.6.git contains at least the following
> xen related new features for Linux 2.6.36:
>
> - Xen-SWIOTLB support (required for Xen PCI passthru and dom0)
> - Xen PV-on-HVM drivers
> - Xen VBD online dynamic resize of guest disks (xvd*)
>
> Congratulations!
>
> What are the plans for 2.6.37 merge window? I believe at least:
> - Xen PCI frontend
>
> Others? I'm going to update the XenParavirtOps and XenKernelFeatures wiki pages..
>
> -- Pasi
>
>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>
>    


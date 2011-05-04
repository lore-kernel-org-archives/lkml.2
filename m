Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1EDRml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:42:41 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:28092 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751674Ab1EDRmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:42:39 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: xJf3j88VM1nhFsXi7tLJn5cI7QWUOdGVwwCMghNn67VwxHp
 eVj3HjmW5S6dv_AIE9qLuew0U4jy9rsI14jQn2HBpUxQmA6HA6VKstgoWSaZ
 ARKtWY1CZTVIkCFOTVlQqMUyaoLrfCEZiRKCTodU2yA98lIYvmt24pNLDck1
 jvJ.qXrDGYMq0DflTPEUBIiUZXVln9lTIiDLuIsJZbmkDFE25fjebxUgxfau
 XDJ.VfpBYGmtML87X1qHDrtd3_VO6fcvkqGr3gRZWFC2UzhQQE8ms8kUOKUV
 Lx4SS2xLDdCH0UC8GQ6xbaxS2a5P0d53vSpfMOn5TOB4KP.GBXanYYjNqccA
 o8rH8rw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DC1900D.3010804@schaufler-ca.com>
Date: Wed, 04 May 2011 10:42:37 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, jmorris@namei.org,
        zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
        kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        eparis@redhat.com, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        viro@zeniv.linux.org.uk, john.johansen@canonical.com,
        apparmor@lists.ubuntu.com, bfields@fieldses.org, neilb@suse.de,
        linux-nfs@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 0/7] File descriptor labeling
References: <201104291139.37489.roberto.sassu@polito.it> <201105021053.54031.roberto.sassu@polito.it> <4DC088A8.4000300@schaufler-ca.com> <201105041119.57493.roberto.sassu@polito.it>
In-Reply-To: <201105041119.57493.roberto.sassu@polito.it>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/2011 2:19 AM, Roberto Sassu wrote:
> On Wednesday, May 04, 2011 12:58:48 AM Casey Schaufler wrote:
>> On 5/2/2011 1:53 AM, Roberto Sassu wrote:
>> ...
>>>> Right, but what I don't understand is why you can't use existing
>>>> mechanisms to achieve this? NFS manages (mostly).
>>> Please, can you explain better this thought?
>> NFS provides a network "view" of an ext4 (or any type for that matter)
>> filesystem. NFS does not support extended attributes, but there has been
>> ongoing work on that. It seems that if NFS does not require the kind
>> of changes you are requesting you shouldn't either.
> I'm not familiar with NFS, so i cannot answer about this scenario.

NFS provides the historical and prototypical example of a layered
filesystem. If you are implementing a layered filesystem and have
not researched NFS you are missing out on the bulk of the experience
and wisdom on the subject.

> I'm adding in CC also the NFS mantainers and the mailing list so
> that they can express their point of view. The whole thread is
> available at:
>
> https://lkml.org/lkml/2011/4/27/201
>
> Roberto Sassu


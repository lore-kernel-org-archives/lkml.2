Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2JIGuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:50:40 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:40209 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab2JIGud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:50:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Zhao Hongjiang <zhaohongjiang37@gmail.com>, jack@suse.cz,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        serge.hallyn@canonical.com, containers@lists.linux-foundation.org
References: <5073BABF.8090206@gmail.com>
	<alpine.LFD.2.00.1210090814420.11244@dhcp-1-104.brq.redhat.com>
Date: Mon, 08 Oct 2012 23:50:26 -0700
In-Reply-To: <alpine.LFD.2.00.1210090814420.11244@dhcp-1-104.brq.redhat.com>
	(=?utf-8?B?Ikx1a8OhxaE=?= Czerner"'s message of "Tue, 9 Oct 2012 08:19:42
 +0200 (CEST)")
Message-ID: <87k3v0cf65.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+NXTOnJSTYzd7PWjjMPhxS+wYCt0Qx/Co=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?***;Luk=c3=a1=c5=a1 Czerner <lczerner@redhat.com>?=
X-Spam-Relay-Country: 
Subject: Re: [PATCH] ext3: fix return values on parse_options() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukáš Czerner <lczerner@redhat.com> writes:

> On Tue, 9 Oct 2012, Zhao Hongjiang wrote:
>
>> Date: Tue, 09 Oct 2012 13:48:47 +0800
>> From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
>> To: jack@suse.cz
>> Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
>>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>>     Eric W. Biederman <ebiederm@xmission.com>, serge.hallyn@canonical.com,
>>     containers@lists.linux-foundation.org
>> Subject: [PATCH] ext3: fix return values on parse_options() failure
>> 
>> From: Zhao Hongjiang <zhaohongjiang@huawei.com>
>> 
>> parse_options() in ext3 should return 0 when parse the mount options fails.
>> 
>
> Ah, it really is a joy to read the parse_options() :). But this fix
> makes sense, thanks for catching it.
>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Ugh.  I goofed that up.  How annoying that ext4 is different than ext3
and ext2 in this regard.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

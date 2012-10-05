Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2JEUdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:33:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58966 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:33:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?B?6rmA7J6s6re5?= <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001401cda2f1$8f16b320$ad441960$%kim@samsung.com>
Date: Fri, 05 Oct 2012 13:33:13 -0700
In-Reply-To: <001401cda2f1$8f16b320$ad441960$%kim@samsung.com>
 (=?utf-8?B?Iuq5gOyerOq3uSIncw==?=
	message of "Fri, 05 Oct 2012 21:04:23 +0900")
Message-ID: <87a9w0slpy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+n7yshZB4dssEx/QIXMSTpEGX148d+DiM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;=ea=b9=80=ec=9e=ac=ea=b7=b9 <jaegeuk.kim@samsung.com>?=
X-Spam-Relay-Country: 
Subject: Re: [PATCH 13/16] f2fs: add xattr and acl functionalities
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

김재극 <jaegeuk.kim@samsung.com> writes:

> This implements xattr and acl functionalities.
>
> - F2FS uses a node page to contain use extended attributes.

Please note the arguments to posix_acl_to_xattr and posix_acl_from_xattr
have changed, which will cause this patch to fail to compile.

Eric

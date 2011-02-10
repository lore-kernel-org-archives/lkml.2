Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1BJDFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:05:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab1BJDFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:05:45 -0500
Message-ID: <4D5355D1.3050408@redhat.com>
Date: Thu, 10 Feb 2011 11:04:49 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "seto.hidetoshi@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2] Controlling kexec behaviour when hardware error
 happened.
References: <5C4C569E8A4B9B42A84A977CF070A35B2C1494DBE0@USINDEVS01.corp.hds.com> <m1bp2l2l31.fsf@fess.ebiederm.org>
In-Reply-To: <m1bp2l2l31.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年02月10日 01:07, Eric W. Biederman 写道:
>
> Is there any reason we can't put logic to decided if we should write
> a crashdump in the crashdump userspace?
>

Doesn't this already provide a choice for the user to decide if he wants
a crashdump via sysctl?

Except some minor issues pointed by you and Greg, this patch looks fine
for me.

Thanks.

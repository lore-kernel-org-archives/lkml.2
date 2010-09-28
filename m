Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab0I1GZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:25:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50446 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab0I1GZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:25:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: caiqian@redhat.com
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
References: <986278020.2030861285581319128.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Date: Mon, 27 Sep 2010 23:25:33 -0700
In-Reply-To: <986278020.2030861285581319128.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	(caiqian@redhat.com's message of "Mon, 27 Sep 2010 05:55:19 -0400
	(EDT)")
Message-ID: <m1vd5qo04i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;caiqian@redhat.com
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/3] Generic support for revoking mappings
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

caiqian@redhat.com writes:

> ----- caiqian@redhat.com wrote:
>
>> ----- "Américo Wang" <xiyou.wangcong@gmail.com> wrote:
>> 
>> > On Mon, Sep 27, 2010 at 04:52:29AM -0400, CAI Qian wrote:
>> > >Just a head up. Tried to boot latest mmotm kernel with those
>> patches
>> > applied hit this. I am wondering what I did wrong.
> The only tricky part of the merge I can tell was for Andrea's commit,

Ok.  This is down right bizarre.
I have it running with the same merge resolution and I'm not seeing
any problems yet.

I will probe deeper tomorrow.  Are you certain you compiled things
properly?

Eric

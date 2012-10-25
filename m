Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220Ab2JYBZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:25:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59664 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2JYBZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:25:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linbao.zhang@hp.com, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
	<20121024182546.GB3338@elie.Belkin>
	<1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
	<20121024194114.GC3120@elie.Belkin>
	<1351117470.6017.91.camel@sbsiddha-desk.sc.intel.com>
	<20121024223100.GB6922@elie.Belkin>
Date: Wed, 24 Oct 2012 18:25:20 -0700
In-Reply-To: <20121024223100.GB6922@elie.Belkin> (Jonathan Nieder's message of
	"Wed, 24 Oct 2012 15:31:00 -0700")
Message-ID: <87txtjqr5r.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18VYyKDFswfmDNrexrKFd9otnO+0BaTBQg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jonathan Nieder <jrnieder@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC/PATCH 2.6.32.y 0/3] Re: [stable 2.6.32..2.6.34] x86, ioapic: initialize nr_ioapic_registers early in mp_register_ioapic()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder <jrnieder@gmail.com> writes:

> Suresh Siddha wrote:
>
>>                               Here is the updated patch with just some
>> more text added to the changelog.
>
> Yes, that's clearer.  For what it's worth,
> Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
>
> Thanks for your patience.

The strange days when code cleanups get backported as bug fixes.
Just this minimal version of things look good.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric


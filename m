Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2DCUPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:15:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52667 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2DCUPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120403195804.GA19239@burratino>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
	<1333102459-23750-1-git-send-email-lenb@kernel.org>
	<3e80acd1af40fcd91a200b0416a7616b20c5d647.1333101989.git.len.brown@intel.com>
	<CA+5PVA4EBdoxgSrYKYRnaO2qSXDP_rxeQEogD+6jkKPi8sQB-g@mail.gmail.com>
	<20120403195804.GA19239@burratino>
Date: Tue, 3 Apr 2012 16:15:32 -0400
Message-ID: <CA+5PVA58jN8S9efACB==o5Z9frEOxVN__wo9yYU6ErQcsKyj8w@mail.gmail.com>
Subject: Re: [3.0.y, 3.2.y, 3.3.y] Re: [PATCH 04/76] ACPICA: Fix regression in
 FADT revision checks
From: Josh Boyer <jwboyer@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Len Brown <len.brown@intel.com>, wzab@ise.pw.edu.pl,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 3:58 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Hi Greg,
>
> Josh Boyer wrote:
>> On Fri, Mar 30, 2012 at 6:13 AM, Len Brown <lenb@kernel.org> wrote:
>
>>> From: Julian Anastasov <ja@ssi.bg>
>>>
>>>        commit 64b3db22c04586997ab4be46dd5a5b99f8a2d390 (2.6.39),
>>> "Remove use of unreliable FADT revision field" causes regression
>>> for old P4 systems because now cst_control and other fields are
>>> not reset to 0.
> [...]
>>>        The fix is to update acpi_gbl_FADT.header.length after
>>> the original value is used to check for old revisions.
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=42700
>>> https://bugzilla.redhat.com/show_bug.cgi?id=727865
>>>
>>> Signed-off-by: Julian Anastasov <ja@ssi.bg>
>>> Acked-by: Bob Moore <robert.moore@intel.com>
>>> Signed-off-by: Len Brown <len.brown@intel.com>
>>
>> This one should go into the stable trees.
>
> Please apply
>
>  3e80acd1af40 "ACPICA: Fix regression in FADT revision checks"
>
> which is in linus's master to the 3.0.y, 3.2.y, and 3.3.y series to
> fix this old boot problem.  (Many affected people disabled HT in the
> BIOS to work around it in the meantime.)
>
> WZab (cc-ed) has tested that the patch addresses the problem when
> applied to the 3.2.y and 3.3.y branches.  [1] has details.

We've had this applied in Fedora on 3.2 and 3.3 for a while now as
well.

josh
